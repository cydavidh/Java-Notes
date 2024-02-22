import requests
from bs4 import BeautifulSoup
import os

# Function to download an image from a URL
def download_image(image_url, save_path):
    response = requests.get(image_url)
    if response.status_code == 200:
        with open(save_path, 'wb') as file:
            file.write(response.content)

# Function to process each URL in the file
def process_urls(file_path):
    with open(file_path, 'r') as file:
        urls = file.read().splitlines()
    
    for url in urls:
        try:
            response = requests.get(url)
            soup = BeautifulSoup(response.text, 'html.parser')
            # Find the specific image element with either class combination
            image_element = soup.find('img', class_=["yesPopunder image_perma_img inner_rounded", "yesPopunder image_perma_img"])
            if image_element and 'src' in image_element.attrs:
                image_url = image_element['src']
                # Ensure the image URL is complete
                if not image_url.startswith(('http:', 'https:')):
                    image_url = 'http:' + image_url
                # Define a save path for the image
                image_name = image_url.split('/')[-1]
                save_path = os.path.join('downloaded_images', image_name)
                # Create the directory if it doesn't exist
                os.makedirs(os.path.dirname(save_path), exist_ok=True)
                # Download the image
                download_image(image_url, save_path)
                print(f"Downloaded: {image_name}")
            else:
                print(f"No image found in {url}")
        except Exception as e:
            print(f"Error processing {url}: {e}")

# Assuming your list of URLs is stored in 'urls.txt'
process_urls('urls.txt')
