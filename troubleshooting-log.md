# Troubleshooting Log

## Incident 1: Nginx service stopped

**What I did:** Ran `sudo systemctl stop nginx` around 13:40 to simulate a failure.

**How I detected it:** My health-check script, running via cron every 5 minutes,
logged "ALERT: nginx is NOT running" at 13:40:01 in health-check.log.

**How I fixed it:** Ran `sudo systemctl start nginx`.

**How I confirmed the fix:** The website loaded again in the browser, and the
next cron run at 13:45:01 logged "OK: nginx is running".


## Incident 2: Disk usage spike

**What I did:** Created a 3GB file with `fallocate` to simulate a disk usage spike.

**How I detected it:** My health-check script logged "WARNING: disk usage is
above 80%" during the next cron run.

**How I fixed it:** Deleted the file with `rm ~/bigfile.img`.

**How I confirmed the fix:** The next cron run showed normal disk usage with
no warning.
