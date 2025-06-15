#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

df = pd.read_csv('alog.tsv', sep='\t', header=None,
                 names=['ip', 'datetime', 'method', 'status', 'size', 'referer', 'url'])

# convert date (12/Nov/2023:09:42:45 +0900)
df['datetime'] = df['datetime'].apply(
    lambda x: datetime.strptime(x.split()[0], "%d/%b/%Y:%H:%M:%S"))

# round time by 1h (2023-11-12 09:00:00)
df['hour'] = df['datetime'].dt.floor('H')

# group by time
access_counts = df.groupby('hour').size()

# plot graph
plt.figure(figsize=(12, 6))
access_counts.plot(kind='line', marker='o')
plt.bar(access_counts.index.astype(str), access_counts.values)
plt.title('Accesses per hour')
plt.xlabel('time')
plt.ylabel('number of access')
plt.grid(True)
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('aplot.png')

# if you have GUI
#plt.show()
