# apache
Tips to review the log of apache httpd web-server

- Total size of response from clients excluding headers.
```
cat access_log|awk '{S+=$10} END {printf("%d MB\n",S/1024/1024)}'
```

- Count the number of accesses from each remote_host 
```
cat access_log|awk '{print $1}'|sort|uniq -c|sort -nr
```

- Count the number of accesses hourly 
```
cat access_log|awk '{print $4}'|cut -b 2-15|sort|uniq -c
```
