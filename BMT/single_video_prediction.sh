#!/bin/bash

source /home/vilab/anaconda3/etc/profile.d/conda.sh

FILENAMES="Arson001_x264.mp4 Arson007_x264.mp4 Explosion002_x264A.mp4  Fighting017_x264A.mp4 Normal_Videos_050_x264.mp4 Robbery002_x264.mp4 Shooting002_x264A.mp4  Arson002_x264.mp4 Burglary001_x264A.mp4  Fighting018_x264A.mp4 Normal_Videos_100_x264.mp4 Robbery003_x264.mp4 Shooting003_x264A.mp4  Vandalism005_x264.mp4 Arson003_x264.mp4 Burglary002_x264A.mp4 Explosion004_x264A.mp4 Fighting019_x264A.mp4 RoadAccidents001_x264.mp4 Robbery004_x264.mp4 Shooting004_x264A.mp4 Stealing006_x264.mp4 Vandalism006_x264.mp4 Arson005_x264.mp4 Burglary003_x264A.mp4 Fighting015_x264A.mp4 RoadAccidents002_x264.mp4 Robbery005_x264.mp4 Shooting005_x264A.mp4 Vandalism002_x264.mp4 Vandalism007_x264.mp4 Arson006_x264.mp4 Explosion001_x264A.mp4 Fighting016_x264A.mp4 Normal_Videos_015_x264.mp4 Shooting001_x264A.mp4 Vandalism003_x264.mp4"


# audio (.wav) system error --> vggish feature generation error
# Shoplifting007_x264
# Stealing003_x264
# Vandalism004_x264
# Explosion003_x264A
# Shoplifting008_x264
# Stealing004_x264
# Shoplifting009_x264
# Shoplifting010_x264
# RoadAccidents003_x264
# Shoplifting006_x264
# Shoplifting012_x264

SUFFIX1='_vggish.npy'
SUFFIX2='_rgb.npy'
SUFFIX3='_flow.npy'

cd ./submodules/video_features
for FILENAME in $FILENAMES
do
    echo $FILENAME
    conda deactivate
    conda activate i3d
    python main.py \
        --feature_type i3d \
        --on_extraction save_numpy \
        --device_ids 0 \
        --extraction_fps 30 \
        --video_paths /home/vilab/anomaly-detection/BMT/sample_output/original/$FILENAME \
        --output_path ../../sample_output/i3d

    conda deactivate
    conda activate vggish
    python main.py \
        --feature_type vggish \
        --on_extraction save_numpy \
        --device_ids 0 \
        --video_paths /home/vilab/anomaly-detection/BMT/sample_output/original/$FILENAME \
        --output_path ../../sample_output/vggish

done

cd ../../
for FILENAME in $FILENAMES
do
    conda deactivate
    conda activate bmt
    python ./sample/single_video_prediction.py \
        --prop_generator_model_path ./sample/best_prop_model.pt \
        --pretrained_cap_model_path ./sample/best_cap_model.pt \
        --vggish_features_path ./sample_output/vggish/${FILENAME:0:-4}$SUFFIX1 \
        --rgb_features_path ./sample_output/i3d/${FILENAME:0:-4}$SUFFIX2 \
        --flow_features_path ./sample_output/i3d/${FILENAME:0:-4}$SUFFIX3 \
        --device_id 0 \
        --max_prop_per_vid 100 \
        --nms_tiou_thresh 0.4 \
        --video_name ${FILENAME:0:-4}
        # --duration_in_secs 35.155 \
done

# process all jsons into a single json
python sample_output/process_json.py

# format captions into videos (borrowed from PDVC)
echo "START VISUALIZATION"
python visualization/visualization.py --input_mp4_folder ./sample_output/original --output_mp4_folder ./sample_output/vis_videos --dvc_file ./sample_output/processed_json.json --output_language en



# ===============================================
# sample captionn generation command
# ===============================================

cd ./submodules/video_features
conda activate i3d
python main.py \
    --feature_type i3d \
    --on_extraction save_numpy \
    --device_ids 0 \
    --extraction_fps 30 \
    --video_paths /home/vilab/anomaly-detection/BMT/sample_output/original/women_long_jump.mp4 \
    --output_path ../../sample_output/i3d

conda activate vggish
python main.py \
    --feature_type vggish \
    --on_extraction save_numpy \
    --device_ids 0 \
    --video_paths /home/vilab/anomaly-detection/BMT/sample_output/original/women_long_jump.mp4 \
    --output_path ../../sample_output/vggish

conda activate bmt
cd ../../
python ./sample/single_video_prediction.py \
        --prop_generator_model_path ./sample/best_prop_model.pt \
        --pretrained_cap_model_path ./sample/best_cap_model.pt \
        --vggish_features_path ./sample_output/vggish/women_long_jump_vggish.npy \
        --rgb_features_path ./sample_output/i3d/women_long_jump_rgb.npy \
        --flow_features_path ./sample_output/i3d/women_long_jump_flow.npy \
        --device_id 0 \
        --max_prop_per_vid 100 \
        --nms_tiou_thresh 0.4 \
        --video_name women_long_jump

# modify paths here
python sample_output/process_json.py


python visualization/visualization.py --input_mp4_folder ./sample_output/demo --output_mp4_folder ./sample_output/demo/vis_videos --dvc_file ./sample_output/demo/processed_json.json --output_language en



