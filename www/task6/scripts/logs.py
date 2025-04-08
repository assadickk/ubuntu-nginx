import os
import time
import subprocess
from datetime import datetime



ACCESS_LOG = "var/www/task6/logs/access.log"
ERROR_LOG = "var/www/task6/logs/error.log"

SUMMARY_LOG = "var/www/task6/logs/summary.log"
CLEAN_LOG = "var/www/task6/logs/log_clean.log"

ERR400_LOG = "var/www/task6/logs/err400.log"
ERR500_LOG = "var/www/task6/logs/err500.log"

max_size = 300 * 1024

def sum_log():
    subprocess.run(f"cat {ACCESS_LOG} {ERROR_LOG} > {SUMMARY_LOG}", shell=True)

def write_codes():
    err500 = f"awk '$9 ~ /^5[0-9]{2}$/' {SUMMARY_LOG} >> {ERR500_LOG}"
    subprocess.run(err500, shell=True)

    err400 = f"awk '$9 ~ /^4[0-9]{2}$/' {SUMMARY_LOG} >> {ERR400_LOG}"
    subprocess.run(err400, shell=True)

def clear_log():
    if os.path.getsize(SUMMARY_LOG) > max_size:
        with open(CLEAN_LOG, "a") as f:
            f.write(f"{datetime.now()} Очистил логи\n")
        open(SUMMARY_LOG, "w").close()
    else:
        open(SUMMARY_LOG, "w").close()

def main():
    while True:
        sum_log()
        sum_log()

        write_codes()

        clear_log()

        time.sleep(5)

if __name__ == "__main__":
    main()