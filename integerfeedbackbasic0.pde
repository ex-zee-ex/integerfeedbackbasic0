import themidibus.*; //Import the library
MidiBus myBus;
//so these are variables that just have to do with the sin wave
float spc, theta2,amp,period,dx,yv,wavew;
//these are a bunch of default variables i use for keyboard controls
float aa,ss, dd, ff, gg, jj, hh,kk;
//these are default variables i use for nanostudio midi controls
float qq, ww, ee, rr, tt, yy, uu, ii,oo;
//these are the arrays where the feedback happens
int[][] pix0;
int[][] pix1;
//cs is cell size is basically resolution
int cs=10;
//some extra variables
int fill1,w,h,siz;

//some default switch variables that aren't used at this moment
//int sw1,sw2,sw3,sw4,sw5,sw6,sw7,sw8;

//my incrementer
float theta;
void setup(){

size(1000,1000,P3D);

/*
this chunk here initializes the variables that work with the sin wave 
*/
spc=cs;
wavew=width+cs;
period=width/2.0;
dx=(TWO_PI/period)*spc;
amp=height/4;



colorMode(HSB,100);

//set up scaling variables so that one can just resize the sketch up there in 
//size and everything else will follow
w=width/cs;
h=height/cs;
siz=(width*height)/(cs*cs);
pix0=new int[w][h];
pix1=new int[w][h];


 MidiBus.list();
 myBus = new MidiBus(this, 0, -1);
 
 
 
// sw1=sw2=sw3=sw4=sw5=sw6=sw7=sw8=1;
 
 
 qq=.1;
}//endsetup

void draw(){
  
  //this stuff is just for sin wave generation
  theta2 +=.005*(1+10*ww);
  float xx=theta2;

for(int i=0;i<w-1;i++){
  
  //here is the bit that actually generates the sin waaaves
  amp=cs*(1+height/2*qq);
  yv=(sin(xx)+1)*amp;
 
  xx+=dx;
  
 
 
 
 
  //j is y
  for(int j=0;j<h-1;j++){
    
    
    //where is everyone
    
    //l is the location we are going to draw a cell at this time
    //pix0 holds all the values from the last iteration of this for loop
    int l=pix0[i][j];
    
    //l_u is the pixel we will look at to compare to our current cell
    //we can shift how far we are looking with the keyboard control d and c
    //modding out the location by h means that both where we look and the resulting
    //feedback wraps around in toroidal universe style
    int l_u=pix0[i][int(abs(j+h/8*dd))%h];
   // int l_r=pix0[int(abs(i+w/8*hh))%w][j];
    
    
    int x=(i)*cs;
    int y=(j)*cs;
    
    //fill1 is the variable we use to control the brightness of our current cell
    //we start out by just giving it the same value as last time and then go thru
    //a couple of rules that either modify or rewrite it before it gets written to the
    //screen and then written to the array
    fill1=l;
    
    
    /*
    this bit here is asking: "is the cell that i am at a cell that this sin wave is 
    crossing thru? if so then i would like to ignore whatever happened last iteration
    and have the color to be totally white please"
    i would like to figure out a way to be more general with this part of the code to allow
    for more general shapes to come into play like maybe having a transform that turns the 
    wave into a circle
    or integrating the superformula
    or bezier curves
    the other thought i had was to get camera input happening here and just set a brightness
    threshold here for what camera stuff pops thru
    */
    if(((y-height/2+amp)<=yv+cs)&&((y-height/2+amp)>=yv-cs)){

    fill1=100;
    }
    
    
   // ***********RULLES***********
   
    //theres like only 2 rules actually lol
   
    
    
    //would b kinda nice to have a rule somewhere that switches off toroid univerise
    //i did that somewhere in another one of these sketches but i forget exactly how
    //for now the feedback wraps around up and down
    
    //is the value of the cell i am at rn less than the value of the cell i am 
    //comparing too?
    if(l<l_u){
     
    //if so then lets make the current value of the cell a weighted average of the
    //two cells.  the exact weight of how the value we are comparing is added is 
    //adjustable by a control.  i usually set these to midi but for now is a keyboard
    //control
    fill1=int(fill1+2*ss*l_u)/2;
      
    }
    
    
    /*
    if(l<l_r){
     
    fill1=int(fill1+2*ss*l_r)/2;
      
    }
    */
    
    
    //this bit here keeps everything from going white out
    //it asks if the value of my current pixel is the exact same this time around as last time
    //and then if so it scales the current value down a bit by an amount controlled by f and v
     if(fill1==pix0[i][j]){
    
       
       //u can chose to scale logarithmically or linearly
       //u will notice that at no point is there any floor or ceiling work done on the value
       //of fill1 so it can go way beyond the expected range of 0 to 100
       //which means wild color glitching occurs p easily and quickly
     
   // fill1=int(fill1*log(1+2*ff));
    
    fill1=int(fill1*(.001+ff));
     
     
    }
    
     noStroke();
    fill(fill1);
    
    //using pushmatrix and popmatrix is crucial for translates and
    //rotates within any loop as they are all additive transformations
    //unless u push and pop the current transformation matrix onto the 
    //transformation stack
    //its not super important to use push and pop and translate with this current
    //geometry but if i wanted to like use 3d boxes instead of rects or rotate things
    //or do things in z space as well its good to have this framework in place
    pushMatrix();
    translate(x,y);
    rect(0,0,cs,cs);
    
    //this part is p untested
    //u def need to increase the cell size alot to get smooth operation
    //and something kind of funny happens with like the background
    //but still seems cool
 // noFill();
 // stroke(fill1);
 // rotateZ(fill1/100);
 // box(cs);
 
 //other ideas for geometry would be go way denser with the cs and use lines
 //do like a beginShape() and draw like the smoother rutt etra ish lines with like z depth
 //and alpha linked to fill1
 //or same diff with beginshape() but instead like do a wire grid that warps...
    popMatrix();
   
     //here we take the value that we wrote to the screen and put it in an array that keeps
     //track of what we drew this time around
     pix1[i][j]=fill1;

  }//endjfor
}//endifor

//after we run thru a complete loop we do another loop that takes all the current 
//cell values and then feeds them into the array for previous cell values 
for(int i=0;i<w;i++){
  for(int j=0;j<h;j++){
pix0[i][j]=pix1[i][j];

  }//endjfor
}//endifor


if(keyPressed){
  if(key=='s'){ss+=.01;}
  if(key=='x'){ss-=.01;}
  if(key=='d'){dd+=.01;}
  if(key=='c'){dd-=.01;}
  if(key=='f'){ff+=.01;}
  if(key=='v'){ff-=.01;}

}//endifkeypressed
 //theta+=.01;
}//enddraw


//theres no midi controls set up at this moment but here is where u can do such a thing
//if u wish to
void controllerChange(int channel, int number, int value) {
  
  //AAALSO note on and note off can be used as switches if i think of it!
  //either on only while note is being held
  //or just a multiply by -1 each time for discrete flipping
  
  // Receive a controllerChange
  /*
  if u don't know yr midi ccs you can uncomment this part here and move each knob
  and the cc will show up as "value" in the console
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
  */
  
  
  /*
  these values are set to nanostudio cc values rn
  for the xy pad if its set to like xy mode then the cc for x and y are 16 and 17
  i'm p sure thats standard on any korg xy pad stuff its like even on my prophecys korg
  log which was like the predecessor to chaos pad
  pitch bend and mod wheel are default cc 1 and 2 for every midi controller
  */
  if(number==20){
    /*
    i try to keep both a bipolor and monopolor version for each cc 
    just for easy swapping back and forth
    */
  qq=(value)/127.0;
   //qq=(value-63)/63.0;

  }
   if(number==21){
  ww=(value)/127.0;
 // ww=(value-63)/63.0;
  }
  if(number==22){
  ee=(value)/127.0;
 // ee=(value-63)/63.0;
  }
  if(number==23){
  rr=(value)/127.0;
 // rr=(value-63)/63.0;
  }
  if(number==24){
  tt=(value)/127.0;
 // tt=(value-63)/63.0;
  }
  if(number==25){
  yy=(value)/127.0;
 // yy=(value-63)/63.0;
  }
  if(number==26){
  uu=(value)/127.0;
 // uu=(value-63)/63.0;
  }
  if(number==27){
  ii=(value)/127.0;
 // ii=(value-63)/63.0;
  }

}//endcontrollerchange
