import os

root_dirs = [r"e:\AI gF\craveai\lib", r"e:\AI gF\craveai\test"]

for root_dir in root_dirs:
    for subdir, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".dart"):
                filepath = os.path.join(subdir, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    new_content = content.replace("package:craveai/", "package:kraveai/")
                    
                    if content != new_content:
                        with open(filepath, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"Updated {filepath}")
                except Exception as e:
                    print(f"Error processing {filepath}: {e}")
