#! /usr/bin/env python
#Modified to remove copy file: Version 1.0 

 
import os
import sys
import shutil
import datetime
import re

import subprocess


def copyFile_and_check(src, dest):
 try:
  
  shutil.copy(src, dest)
  if(os.path.getsize(src)!=os.path.getsize(dest)):
   os.unlink(pidfile)
   print "Copy file size is not matching. I will try replay later"
   if os.path.exists(dest):
    os.remove(dest)
   os.unlink(dest)
   return 2
  fo = open( src,"rw+")
  fo.truncate()
  fo.close()
  return 1
 except shutil.Error as e:
   print('Error: %s' % e)
   os.unlink(pidfile)
    # eg. source or destination doesn't exist
 except IOError as e:
        print('Error: %s' % e.strerror)
	os.unlink(pidfile)

if len(sys.argv) == 2:

   host_port = '127.0.0.1:1463'

   filename = sys.argv[1]

elif len(sys.argv) == 4 and sys.argv[1] == '-h':

   host_port = sys.argv[2]

   filename = sys.argv[3]

else:

   sys.exit('Usage: scribe_resend.py [-h host[:port]] path-to-scribe-failover-log')

try:
 pid = str(os.getpid())
 pidfile = "/tmp/replay.pid"

 if os.path.isfile(pidfile):
    print "%s already exists, exiting" % pidfile
    sys.exit()
 else:
    file(pidfile, 'w').write(pid)
#print 'Sending messages from {0} to {1}'.format(filename, host_port)
 if(os.path.getsize(filename)==0):
  print "File size is zero exiting"
  sys.exit(2)
 print 'Sending messages from {0} to {1}'.format(filename, host_port)
 count = 0
 d=datetime.datetime.now().strftime("%Y-%m-%d_%H_%M_%S")
 copy_file=filename+"_replay_copy_"+d
 status=copyFile_and_check(filename,copy_file)
 if(status!=1):
  os.unlink(pidfile)
  exit(2)
 pattern = re.compile('(\w+)\|(.*)', flags=re.DOTALL)
 try:
  with open(copy_file, 'r') as failover_log:

   for line in failover_log:

       match = pattern.match(line)

       if match:

          

           category = match.group(1)

           message = match.group(2)

           process = subprocess.Popen(['scribe_cat', '-h', host_port, category], stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE, )
  
           
           out,err=process.communicate(input=message)
           
           if err:
            print "Found error file need to retry"
            open(filename+"replay_failed.log",'a')
            os.unlink(pidfile)
            exit(2)
           else:
            count += 1
           
 except :
  open(filename+"replay_failed.log",'a')
  os.unlink(pidfile)
  print "Unexpected error:", sys.exc_info()[0]
  exit(2)
 print 'Sent {0} messages'.format(count)
 if os.path.isfile(copy_file):
  os.remove(copy_file)
 os.unlink(pidfile)
finally:
 #print "Unexpected error:", sys.exc_info()[0]
 if os.path.isfile(pidfile):
  os.unlink(pidfile)
