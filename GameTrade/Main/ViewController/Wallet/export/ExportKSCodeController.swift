//
//  ExportKSCodeController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/22.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ExportKSCodeController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentSize_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var codeImageView: UIImageView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var waringImageView: UIImageView!
    @IBOutlet weak var showButton: UIButton!
    
    var backBlock : (()->())?
    var keystoreStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func show(_ sender: Any) {
        self.codeImageView.image = self.code(self.keystoreStr)
        self.confirmView.removeFromSuperview()
    }
    
    func code(_ string:String) -> UIImage {
        //二维码滤镜
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        //设置滤镜默认属性
        filter?.setDefaults()
        
        let data = string.data(using: .utf8)
        
        //设置内容
        filter?.setValue(data, forKey: "inputMessage")
        //设置纠错级别
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        //获取滤镜输出图像
        guard let outImage = filter?.outputImage else{
            return UIImage()
        }
        //转换CIIamge为UIImage,并放大显示
        guard let image = self.createNonInterpolatedUIImage(outImage, size: self.codeImageView.frame.size) else {
            return UIImage()
        }
        return image
    }
    func createNonInterpolatedUIImage(_ ciImage : CIImage,size:CGSize) -> UIImage? {
        let a = size.height
        
        let extent = ciImage.extent.integral
        let scale = min(a / extent.size.width, a / extent.size.height)
        //创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        let context = CIContext.init()
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else {
            return nil
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        //保存bitmap到图片
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        let image = UIImage.init(cgImage: scaledImage)
        return image
    }
    func imageBlackToTransparent(_ image:UIImage,red:CGFloat,green:CGFloat,blue:CGFloat) -> UIImage {
        let imageWidth = Int(image.size.width)
        let imageHeight = Int(image.size.height)
        
        let bytesPerRow = imageWidth * 4
        let rgbImageBuf = malloc(bytesPerRow * imageHeight)
        //create context
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: rgbImageBuf, width: imageWidth, height: imageHeight, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: UInt32(UInt8(CGBitmapInfo.byteOrder32Little.rawValue) | UInt8(CGImageAlphaInfo.noneSkipLast.rawValue)))
        context?.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        //traverse pixe
//        let piexlNum = imageHeight * imageWidth
//        var pCurPtr = rgbImageBuf
//        for i in 0..<piexlNum {
//
//            let a = withUnsafeMutablePointer(to: &pCurPtr) { (pointer) -> Result in
//
//                return 
//            }
//            if ( & 0xFFFFFF00) < 0x99999900 {
//
//            }
//        }
        
        /*
 uint32_t* pCurPtr = rgbImageBuf;
 for (int i = 0; i < pixelNum; i++, pCurPtr++){
 if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
 // change color
 uint8_t* ptr = (uint8_t*)pCurPtr;
 ptr[3] = red; //0~255
 ptr[2] = green;
 ptr[1] = blue;
 }else{
 uint8_t* ptr = (uint8_t*)pCurPtr;
 ptr[0] = 0;
 }
 }
 // context to image
 CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
 CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
 kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
 NULL, true, kCGRenderingIntentDefault);
 CGDataProviderRelease(dataProvider);
 UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
 // release
 CGImageRelease(imageRef);
 CGContextRelease(context);
 CGColorSpaceRelease(colorSpace);
 return resultUIImage;
        
        
        */
        return UIImage()
        
    }
}
