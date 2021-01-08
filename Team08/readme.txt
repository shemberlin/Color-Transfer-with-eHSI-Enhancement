執行方法:
直接執行Demo.m即可開啟程式

介面介紹:
原圖為顯示是原圖，需選擇圖片檔
色彩轉換顯示為參考圖片，需選擇圖片檔
輸入影像大小為imresize功能

顯示結果:
如果先執行色彩強化的話，就會顯示由左至右分別為eHSI強化結果、傳統HSI結果、先eHSI在color transfer後的結果
如果先執行色彩轉換的話，就會顯示由左至右分別為color transfer後結果、color transfer後結果在傳統HSI結果、color transfer後再eHSI的結果

程序說明:
步驟1，先案原圖的開啟檔案，選擇想要的圖片，選擇你想轉換的圖片
步驟2，在案參考圖片的開啟檔案，選擇參考圖片
步驟3，速度太慢的話，可以將影像縮放
步驟4，選擇要先做color transfer(色彩轉換) 或是先做eHSI(色彩強化)，選擇完後按下執行，即可瀏覽結果。

資料夾介紹:
image資料夾裡為圖片
colorTransform為色彩轉換
ehsi2rgb，hsi2rgb為ehsi色彩空間轉換
ehsiEnhancement再ehsi做histgram eqlization和 s-type轉換
rgb2hsi，hsi2rgb為傳統hsi色彩空間轉換
progressbar為GUI相關程式
kmeansClustering為影像分割程式