import cv2
import numpy as np

T = 190
def mask_real(_img, threshold=np.array([T,T,T], dtype=np.uint8)):
    img = _img.copy()
    img[(_img>=threshold).all(-1)] = np.array([127,127,127], dtype=np.uint8)
    return img

def mask_binary(_img, threshold=np.array([T,T,T], dtype=np.uint8)):
    img = _img.copy()
    img[(_img>=threshold).all(-1)] = np.zeros(3, dtype=np.uint8)
    img[~(_img>=threshold).all(-1)] = np.ones(3, dtype=np.uint8)*255
    return img

for x in range(1,5):
    img_path = f'cloth-{x}.jpg'
    img_masked_path = f'cloth-{x}_masked.jpg'
    IMG = cv2.imread(img_path)
    cv2.imwrite('test_clothes/' + img_path, mask_real(IMG))
    cv2.imwrite('test_edge/' + img_masked_path, mask_binary(IMG))
