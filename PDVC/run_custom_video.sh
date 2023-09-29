video_folder=visualization/sample/videos
output_folder=visualization/sample/output2
pdvc_model_path=save/anet_tsp_pdvc/model-best.pth
output_language=en
bash test_and_visualize.sh $video_folder $output_folder $pdvc_model_path $output_language

#video_folder=visualization/ucfcrime/original
#output_folder=visualization/ucfcrime/output
#pdvc_model_path=save/anet_tsp_pdvc/model-best.pth
#output_language=en
#bash test_and_visualize.sh $video_folder $output_folder $pdvc_model_path $output_language

#video_folder=visualization/newucfcrime2/original
#output_folder=visualization/newucfcrime2/output
#pdvc_model_path=save/anet_tsp_pdvc/model-best.pth
#output_language=en
#bash test_and_visualize.sh $video_folder $output_folder $pdvc_model_path $output_language