import time
import subprocess

while True:
    cmd = "top -bn1"
    cpu = subprocess.check_output(cmd, shell=True).decode().strip()
    
    with open("/var/www/task6/logs/cpu.log", "w") as f:
        f.write(cpu)
    
    time.sleep(1)