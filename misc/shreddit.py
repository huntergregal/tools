#!/usr/bin/env python3
import praw
#from IPython import embed


USER = '' # username
PASSWORD = '' # password
SECRET = '' # from reddit.com/prefs/apps when you create app
CID =  '' # from reddit.com/prefs/apps
shred_posts = True
SHRED_TEXT = '[REDACTED]'

reddit = praw.Reddit(client_id=CID,
                     client_secret=SECRET,
                     password=PASSWORD,
                     user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36',
                     username=USER)
reddit.validate_on_submit = True

print('[+] Shredding old comments...')
redditor = reddit.redditor(USER)

'''
Shred comments
'''
i = 0
while True:
    comments = redditor.comments.new()
    for comment in comments:
        comment.edit(SHRED_TEXT)
        comment.delete()
        i += 1
        print(f' [-] Comment {i} shredded')
print(f'    [-] {i} comments shredded')

'''
Shred posts
'''
if shred_posts:
    print('[+] Shredding posts...')
    i = 0
    posts = redditor.submissions.new()
    for post in posts:
        post.delete()
        i += 1
        print(f' [-] Post {i} shredded')
    print(f'    [-] {i} posts shredded')
print('[+] Complete')
#embed(colors='linux')
