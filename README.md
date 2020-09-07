# Entropy Toolkit

![entropy](https://user-images.githubusercontent.com/54115104/74149935-04b43100-4c1a-11ea-8bba-d2663b02184a.jpeg)

<p align="center">
  <a href="http://entynetproject.simplesite.com/">
    <img src="https://img.shields.io/badge/entynetproject-Ivan%20Nikolsky-blue.svg">
  </a>
  <a href="https://github.com/entynetproject/entropy/releases">
    <img src="https://img.shields.io/github/release/entynetproject/entropy.svg">
  </a>
  <a href="https://wikipedia.org/wiki/Python_(programming_language)">
    <img src="https://img.shields.io/badge/language-python-blue.svg">
 </a>
  <a href="https://github.com/entynetproject/entropy/issues?q=is%3Aissue+is%3Aclosed">
      <img src="https://img.shields.io/github/issues/entynetproject/entropy.svg">
  </a>
  <a href="https://github.com/entynetproject/entropy/wiki">
      <img src="https://img.shields.io/badge/wiki%20-entropy-lightgrey.svg">
 </a>
  <a href="https://twitter.com/entynetproject">
    <img src="https://img.shields.io/badge/twitter-entynetproject-blue.svg">
 </a>
  <a href="https://github.com/vanpersiexp/expcamera">
    <img src="https://img.shields.io/badge/based%20on-ExpCamera-red.svg">
 </a>
</p>

***

# About Entropy Toolkit

```
Entropy Toolkit is a set of tools to provide Netwave 
and GoAhead IP webcams attacks. Entropy Toolkit is a 
powerful toolkit for webcams penetration testing.
```

***

# Getting started

## Entropy installation

> cd entropy

> chmod +x install.sh

> ./install.sh

## Entropy uninstallation

> cd entropy

> chmod +x uninstall.sh

> ./uninstall.sh

***

# Entropy Toolkit execution

```
To run Entropy Toolkit you should 
execute the following command.
```

> entropy

```
usage: entropy [-h] [-b [1|2]] [-o <output_path>] [--timeout <timeout>]
               [-t <tasks>] [-c <count>] [-q | -v]
               [-a <ip:port> | -i <input_file> | --shodan <api> | --zoomeye <api>]
               [-u] [--version]

optional arguments:
  -h, --help            show this help message and exit
  -b [1|2], --brand [1|2]
                        Choose the brand of IP webcam. (1)Netwave, (2)GoAhead.
  -o <output_path>, --output <output_path>
                        Output to the specified path.
  --timeout <timeout>   Timeout in seconds.
  -t <tasks>, --task <tasks>
                        Run tasks number of connects in parallel.
  -c <count>, --count <count>
                        The number of IP you want to get.
  -q, --quiet           Quiet mode.
  -v, --verbose         Verbose mode.
  -a <ip:port>, --address <ip:port>
                        IP and port of the webcam.
  -i <input_file>, --input <input_file>
                        List of webcams addresses.
  --shodan <api>        Attack through Shodan.
  --zoomeye <api>       Attack through ZoomEye.
  -u, --update          Update Entropy Toolkit.
  --version             Show Entropy Toolkit version.
```

***

# Entropy Toolkit examples

## Example of attacking a single webcam
    
> entropy -b 1 -i 192.168.1.100:80 -v  

## Example of attacking webcams from a file

> entropy -b 2 -l iplist.txt -v

## Example of attacking webcams through Shodan

> entropy -b 2 -v --shodan PSKINdQe1GyxGgecYz2191H2JoS9qvgD

***

# Entropy Toolkit disclaimer

```
Usage of the Entropy Toolkit for attacking targets without prior mutual consent is illegal.
It is the end user's responsibility to obey all applicable local, state, federal, and international laws.
Developers assume no liability and are not responsible for any misuse or damage caused by this program.
```
