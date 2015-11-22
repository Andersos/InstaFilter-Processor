//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

class Filter {
    var option: Int = 0
    var filter: ((Pixel, Int) -> (Pixel))
    
    init(filter: ((Pixel, Int) -> (Pixel)), option: Int) {
        self.option = option
        self.filter = filter
    }
}


func swapColor(var pixel: Pixel, option: Int) -> Pixel {
    if(option == 0) {
        let temp = pixel.red
        pixel.red = pixel.blue
        pixel.blue = pixel.green
        pixel.green = temp
    } else {
        let temp = pixel.blue
        pixel.blue = pixel.red
        pixel.red = pixel.green
        pixel.green = temp
    }
    return pixel
}

// Make the colorSwapper filter
let colorSwapFilter = Filter(filter: swapColor, option: 0)

func removeColor(var pixel: Pixel, option: Int) -> Pixel {
    if(option == 0) {
        pixel.red = 0
    } else if(option == 1) {
        pixel.green = 0
    } else if(option == 2) {
        pixel.blue = 0
    }
    
    return pixel
}

// Make the removeColorFilter
let removeColorFilter = Filter(filter: removeColor, option: 0)

func changeTransperency(var pixel: Pixel, transperency: Int) -> Pixel {
    pixel.alpha = UInt8(max(min(255, transperency), 0))
    return pixel
}

// Make the transperencyFilter
let transperencyFilter = Filter(filter: changeTransperency, option: 210)

func changeContrast(var pixel: Pixel, modifier: Int) -> Pixel {
    let avgRed = 118
    let avgGreen = 98
    let avgBlue = 83
    let redDelta = Int(pixel.red) - avgRed
    let greenDelta = Int(pixel.green) - avgGreen
    let blueDelta = Int(pixel.blue) - avgBlue
    pixel.red = UInt8(max(min(255, avgRed + modifier * redDelta), 0))
    pixel.green = UInt8(max(min(255, avgGreen + modifier * greenDelta), 0))
    pixel.blue = UInt8(max(min(255, avgBlue + modifier * blueDelta), 0))
    return pixel
}

// Make the contrastFilter
let contrastFilter = Filter(filter: changeContrast, option: 2)

func colorSubtract(var pixel: Pixel, value: Int) -> Pixel {
    pixel.red = UInt8(value) - pixel.red
    pixel.green = UInt8(value) - pixel.green
    pixel.blue = UInt8(value) - pixel.blue
    return pixel
}

// Make subtractionFilter
let subtractionFilter = Filter(filter: colorSubtract, option: 255)

class ImageProcessor {
    var filterList: [Filter] = []
    
    func addFilter(filter: String){
        filterList.append(availableFilters[filter]!)
    }
    
    var availableFilters: [String: Filter] = [
        "colorSwapFilter": colorSwapFilter,
        "transperencyFilter": transperencyFilter,
        "removeColorFilter": removeColorFilter,
        "contrastFilter": contrastFilter,
        "subtractionFilter": subtractionFilter
    ]
    
    func processImage(image: UIImage) -> UIImage {
        let rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                for filter in filterList {
                    let pixel = rgbaImage.pixels[index]
                    rgbaImage.pixels[index] = filter.filter(pixel, filter.option)
                }
                
            }
        }
        return rgbaImage.toUIImage()!
    }
}

// Making the image processor
var imageProcessor: ImageProcessor = ImageProcessor()

// Adding 5 filters
imageProcessor.addFilter("contrastFilter")
imageProcessor.addFilter("colorSwapFilter")
imageProcessor.addFilter("subtractionFilter")
imageProcessor.addFilter("removeColorFilter")
imageProcessor.addFilter("transperencyFilter")

// Processing the image
imageProcessor.processImage(image)





