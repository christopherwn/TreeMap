// Code from Visualizing Data, First Edition, Copyright 2008 Ben Fry.


class FileItem extends SimpleMapItem {
  FolderItem parent;    
  File file;
  String name;
  int level;
  
  color c;
  float hue;
  float brightness;
    
  float textPadding = 8;
    
  float boxLeft, boxTop;
  float boxRight, boxBottom;


  FileItem(FolderItem parent, File file, int level, int order) {
    this.parent = parent;
    this.file = file;
    this.order = order;
    this.level = level;
      
    name = file.getName();
    size = file.length();

    modTimes.add(file.lastModified());
  }

  
  void updateColors() {
    if (parent != null) {
      hue = map(order, 0, parent.getItemCount(), 0, 360);
    }
    brightness = modTimes.percentile(file.lastModified()) * 100;

    colorMode(HSB, 360, 100, 100);
    if (parent == zoomItem) {
      c = color(hue, 80, 80);
    } else if (parent != null) {
      c = color(parent.hue, 80, brightness);
    }
    colorMode(RGB, 255);
  }
  
  
  void calcBox() {
    boxLeft = zoomBounds.spanX(x, 0, width);
    boxRight = zoomBounds.spanX(x+w, 0, width);
    boxTop = zoomBounds.spanY(y, 0, height);
    boxBottom = zoomBounds.spanY(y+h, 0, height);
  }


  void draw() {
    calcBox();

    fill(c);
    rect(boxLeft, boxTop, boxRight, boxBottom);

    //if you determine the file is a jpg/png/gif
    //remember that file.getFileName() returns a string that is the filename
    //use indexOF and/or other string functions to check the letters after the .
    //then draw the image using the absolute file path
     PImage img = loadImage(file.getAbsolutePath());
  
   String s = file.getName().toLowerCase();
   if(s.indexOf(".jpg")!=-1||s.indexOf(".jpeg")!=-1||s.indexOf(".png")!=-1||s.indexOf(".gif")!=-1){
      image(img,this.boxLeft,this.boxTop,this.boxRight-boxLeft,this.boxBottom-boxTop);
   } 
   else if(s.indexOf(".txt")!=-1||s.indexOf(".tsv")!=-1||s.indexOf(".csv")!=-1){
    
     String lines[] = loadStrings(file.getAbsolutePath());
      
     String x = join(lines," ");
     text(x,this.boxLeft,this.boxTop,this.boxRight-boxLeft,this.boxBottom-boxTop);
   } 
     
      
      

    if (textFits()) {
      drawTitle();
    } else if (mouseInside()) {
      rolloverItem = this;
    }
   }
    
    
  void drawTitle() {
    fill(255, 200);
    
    float middleX = (boxLeft + boxRight) / 2;
    float middleY = (boxTop + boxBottom) / 2;
    if (middleX > 0 && middleX < width && middleY > 0 && middleY < height) {
      if (boxLeft + textWidth(name) + textPadding*2 > width) {
        textAlign(RIGHT);
        text(name, width - textPadding, boxBottom - textPadding);
      } else {
        textAlign(LEFT);
        text(name, boxLeft + textPadding, boxBottom - textPadding);
      }
    }
  }


  boolean textFits() {
    float wide = textWidth(name) + textPadding*2;
    float high = textAscent() + textDescent() + textPadding*2;
    return (boxRight - boxLeft > wide) && (boxBottom - boxTop > high); 
  }
    
 
  boolean mouseInside() {
    return (mouseX > boxLeft && mouseX < boxRight && 
            mouseY > boxTop && mouseY < boxBottom);    
  }


  boolean mousePressed() {
    if (mouseInside()) {
      if (mouseButton == LEFT) {
        open(file.getAbsolutePath());
        parent.zoomIn();
        return true;

      } else if (mouseButton == RIGHT) {
        if (parent == zoomItem) {
          parent.zoomOut();
        } else {
          parent.hideContents();
        }
        return true;
      }
    }
    return false;
  }
}
