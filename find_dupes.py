
import re
import collections

def find_duplicate_keys(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by maps
    # This regex is a bit loose to catch all string maps
    map_blocks = re.split(r'Map<String, String> _\w+ = {', content)
    
    for i in range(1, len(map_blocks)):
        block = map_blocks[i]
        # Find all keys in this block
        # Key is " 'word': " or " "word": "
        keys = re.findall(r"['\"](\w+)['\"]\s*:", block)
        
        counts = collections.Counter(keys)
        duplicates = [k for k, c in counts.items() if c > 1]
        
        if duplicates:
            print(f"Map block {i} has duplicate keys: {', '.join(duplicates)}")
        else:
            print(f"Map block {i} has no duplicate keys.")

find_duplicate_keys(r'd:\zakaz_af\mobile_app\lib\core\localization\app_translations.dart')
