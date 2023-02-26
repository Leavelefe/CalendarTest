import json
from datetime import datetime, timedelta

# 读取 data.json 文件
with open('data.json', 'r') as f:
    data = json.load(f)

with open('buffer.json', 'r') as f:
    data2 = json.load(f)
# 生成新的 JSON 数据
result = []
date = datetime.strptime('20230101', '%Y%m%d')
while date.strftime('%Y%m%d') != '20240101':
    todo = 0
    for item in data:
        if item['day'] == date.strftime('%Y%m%d') and item['stockType'] != 3:
            todo = 1
            break
    if todo == 0:
        for item in data2:
            if item['day'] == date.strftime('%Y%m%d'):
                todo = 1
                break
    result.append({'time': date.strftime('%Y%m%d'), 'todo': todo})
    date += timedelta(days=1)

# 保存新的 JSON 数据
with open('result3.json', 'w') as f:
    json.dump(result, f)
