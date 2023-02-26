import json
import random
from datetime import datetime, timedelta

def generate_json():
    data = []
    id_set = set()
    current_date = datetime(2023, 1, 1)
    while len(data) < 100: # 生成100条数据
        current_id = random.randint(1, 1000)
        if current_id in id_set:
            continue
        id_set.add(current_id)
        current_time = None
        if random.random() < 0.5:
            current_time = datetime(2023, 1, 1) + timedelta(minutes=random.randint(0, 1439))
            current_time = current_time.strftime("%H:%M")
        current_title = generate_title()
        current_content = None
        if random.random() < 0.5:
            current_content = generate_content()
        current_previos_value = None
        if current_time is not None:
            current_previos_value = round(random.uniform(1, 10), 1)
        current_info_type = random.randint(1, 4)
        data.append({
            "id": str(current_id),
            "day": current_date.strftime("%Y%m%d"),
            "time": current_time,
            "title": current_title,
            "content": current_content,
            "previosValue": current_previos_value,
            "infoType": current_info_type
        })
        current_date += timedelta(days=random.randint(0, 3))
    return json.dumps(data)

def generate_title():
    title_length = random.randint(5, 15)
    title = ""
    for i in range(title_length):
        title += chr(random.randint(0x4e00, 0x9fff))
    print(title)
    return title

def generate_content():
    content_length = random.randint(20, 30)
    content = ""
    for i in range(content_length):
        content += chr(random.randint(0x4e00, 0x9fff))
    return content

json_data = generate_json()
print(json_data)
with open('data.json', 'w', encoding='utf-8') as f:
    f.write(json_data)
