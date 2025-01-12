------------------------------------------------------------------------------------------------------------------------
Hello everyone, this script is capable of making a CSV file of data that was captured on a network interface.
This data is captured using Tshark, which is a CLI, terminal or command prompt based variant of Wireshark.
Tshark's network traffic capture filters help us capture the data that we require.
To test this you can use the attack scripts. The attack scripts use Hping3 and Nmap for performing SYN DOS attack.
This script has to be run on the system that wants to monitor the communication between the devices. 
This script requires bash and superuser permissions to run.
------------------------------------------------------------------------------------------------------------------------
This script requires 3 parameters, these parameters are 
OUTPUT_DIR
ALL_LOG_DIR
INTERFACE
------------------------------------------------------------------------------------------------------------------------

$INTERFACE is the interface on which you want to capture the traffic.
This can be found by typing "ipconfig" in window's command prompt and by typing "ifconfig" in Unix based systems..

$OUTPUT_DIR is the directory where everything will be stored temporarily before clubbing it with the previous file and storing it at
$ALL_LOG_DIR.

$ALL_LOG_DIR is the directory where after all the files are clubbed, they get stored here.
