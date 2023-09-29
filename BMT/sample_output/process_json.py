import os
import json
from easydict import EasyDict as edict
import subprocess
output = edict({"results": {}})

for root, dirs, files in os.walk("./sample_output/captions", topdown=True):
    for file in files: # only accpet 'json' suffix
        if file.split('.')[-1] == 'mp4': continue
        print(file)
        duration_in_secs = float(subprocess.check_output(f"ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 sample_output/original/{file[:-5]}.mp4", shell=True))
        
        contents = json.load(open(os.path.join(root, file), 'r'))
        file_outputs = []
        for idx, content in enumerate(contents):            
            
            # metadata_csv_path = './sample_output/metadata.csv'
            # import pandas as pd
            # df = pd.read_csv(metadata_csv_path)
            # for i, row in df.iterrows():
            #     if file[:-5] == row['filename']:
            #         duration_in_secs = row['video-duration']
            #         print("duration found!", duration_in_secs)
            #         break
                
            file_output = [
                {
                    "timestamp": [content["start"], content["end"]],
                    "raw_box":  [content["start"], content["end"]],
                    "proposal_score": 0,
                    "sentence": content["sentence"],
                    "sentence_score": 0,
                    "query_id": idx,
                    "vid_duration": duration_in_secs,
                    "pred_event_count": len(contents)
                    
                }
            ]
            file_outputs.extend(file_output)
        output["results"].update({f"{file[:-5]}": file_outputs}) # caption per file
        print(output)
json.dump(output, open("./sample_output/processed_json.json", "w"), indent=6)