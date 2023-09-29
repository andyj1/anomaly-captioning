### anomaly-captioning
This repository contains the code for visualizing inferenced video captioining results on anomaly videos (e.g., UCF Crime dataset)

To run PDVC inference, follow [PDVC](PDVC/PDVC_original) to download the weights to: [model-best.pth](PDVC/save/anet_tsp_pdvc/model-best.pth) and prepare test videos (at: ```PDVC/visualization/sample/videos```). Then run ```run_custom_video.sh``` and check the output at ```PDVC/visualization/sample/videos```.

To run BMT, follow [BMT](BMT/BMT_original/) or [tutorial](BMT/colab_demo_BMT.ipynb) to download the pretrained weights. Then follow the [script](BMT/single_video_prediction.sh) for inference steps. Download the weights to: [best_prop_model.pt](BMT/sample/best_prop_model.pt) and [best_cap_model.pt](BMT/sample/best_cap_model.pt). Prepare test videos, process the generated captions (.json) and visualize the captioned video outputs at ```BMT/sample_output```.