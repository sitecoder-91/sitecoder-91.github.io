import os
import sys

# Try importing cv2
try:
    import cv2
except ImportError:
    print("Error: opencv-python is not installed. Please run: pip install opencv-python")
    print("Or install ffmpeg on your system (e.g. brew install ffmpeg) to generate thumbnails.")
    sys.exit(1)

media_dir = "assets/media"
output_dir = "assets/img/thumbnails"

if not os.path.exists(output_dir):
    os.makedirs(output_dir)

print("Generating thumbnails using OpenCV...")

for file in os.listdir(media_dir):
    if file.lower().endswith(('.mp4', '.mov', '.webm')):
        video_path = os.path.join(media_dir, file)
        output_path = os.path.join(output_dir, os.path.splitext(file)[0] + ".jpg")
        
        print(f"Extracting frame from {file}...")
        vidcap = cv2.VideoCapture(video_path)
        # Try to read frame at 0.5 seconds. 0.5s = 500ms
        vidcap.set(cv2.CAP_PROP_POS_MSEC, 500)
        success, image = vidcap.read()
        if not success:
            # Fallback to first frame if 500ms fails
            vidcap.set(cv2.CAP_PROP_POS_MSEC, 0)
            success, image = vidcap.read()
            
        if success:
            cv2.imwrite(output_path, image)
            print(f"Saved: {output_path}")
        else:
            print(f"Failed to extract frame from {file}")
            
        vidcap.release()

print("Done.")
