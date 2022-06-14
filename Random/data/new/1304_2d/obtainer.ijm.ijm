Roi.getBounds(rx, ry, width, height); 
row = 0; 

for(y=ry; y<ry+height; y++) { 
    for(x=rx; x<rx+width; x++) { 
        if(Roi.contains(x, y)==1) { 
            setResult("X", row, x); 
            setResult("Y", row, y); 
            setResult("Value", row, getPixel(x, y)); 
            row++; 
        } 
    } 
} 