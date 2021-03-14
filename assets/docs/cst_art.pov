/* 
 Art for 'conformal sites theory' in Langmuir (doi:10.1021/acs.langmuir.9b03633)
 Author: Kaihang Shi
 Email : kshi3@ncsu.edu
 Date  : Jan 18, 2020
*/

/*
Note: Pov-ray uses left-handed coordinate system <x,y,z>, 
      with x pointing in the right, y pointing up and z into the screen. 
*/         

// ------------- Files with predefined colors and textures
#include "colors.inc"             
#include "textures.inc"
#include "glass.inc"
#include "golds.inc"
#include "metals.inc"
#include "woods.inc"  
#include "stones.inc"
#include "shapes.inc"
#include "functions.inc"

//
#default{ finish{ ambient 0.2 diffuse 0.9 }}
//Ambient light to "brighten up" darker pictures
//global_settings { ambient_light White }


// ------------- Place the camera
camera 
{   
  location <5, 5,-12>             // Camera location
  right 8.19*x/10                 // x*image_width/image_height
  //location <0,20,-15>             // top view
  look_at   <0,0,0>               //Where camera is pointing
  angle 17                        //Angle of the view--increase to see more, decrease to see less 
  aperture .1                     // [0...N] larger is narrower depth of field (blurrier)
  blur_samples 100                  // number of rays per pixel for sampling. The larger the better.
  focal_point <1.3,0.25,-2.8>      // point that is in focus <X,Y,Z>
  confidence 1.0                   // [0...<1] when to move on while sampling (smaller is less accurate)
  variance 1/10000                  // [0...1] how precise to calculate (smaller is more accurate)
  
}



// ------------ Place a light--you can have more than one!
light_source {  
  <5,5,-6>                 // light's position (translated below)
  color White       // light's color
  area_light
  <5, 0, 0> <0, 0, 5> // lights spread out across this distance (x * z)
  5, 5                // total number of lights in grid 
  adaptive 1          // 0,1,2,3...
  jitter              // adds random softening of light
  circular            // make the shape of the light circular
  orient              // orient light        
  //fade_distance 20
  //fade_power 1
}


// ----------- Bottom plane 
/*plane
{
    y,0 
    pigment {
    color Black
    }
    finish {
      ambient 0.1
      diffuse 0.9
      reflection .1
      specular 0.3
      roughness .1
      metallic
      phong .5
   }

}*/ 


plane
{ y, 0
    texture
    { average texture_map
      { #declare S = seed(0);
        #local ReflColor = .8*<0, 0, 0> + .2*<1, 1, 1>;
        #declare Ind = 0;
        #while(Ind < 20)
          [1 pigment { rgb <0, 0, 0> }
             normal { bumps .1 translate <rand(S),rand(S),rand(S)>*100 scale .001 }
             finish { 
                specular .6
                roughness .2
                reflection { ReflColor*.1, ReflColor*.5} 
             }
             
          ]
        #declare Ind = Ind+1;
        #end
      }
    }
    
} 


 
// --------------- Set a background color
background { color Black }


//--------------- Define a general surface model
#declare surf=isosurface {
    function {y + f_noise3d(x,10,z)*0.2}
    threshold 0.25
    contained_by { 
        box {
            < -0.8, 0, -6>, 
            < 2.2, 5,  -3>
        }
    } open 
}
 
 
// Define a water molecule
#declare atomscale=3;
#declare wat=union {
    // Oxygen
    sphere {
        <0.0, -0.2222289175, -0.3142720476>, 0.37*atomscale
        pigment {color Red }
        texture {Glass}    
    }  
    // Hydrogen
    sphere {
        <0.0, 0.7777710825, -0.3142720476>, 0.27*atomscale
        pigment {color White}
        texture {Glass}
    }
    sphere {
        <0.0, -0.5555421651, 0.6285440951>, 0.27*atomscale
        pigment {color White}
        texture {Glass}
    }
    
    scale .06
    
}




//-------- Scene Start ------------//
///*
// ------------ Reference surface
#declare refsurf=intersection{
    // top surface
    isosurface {
        surf
        pigment {
            color rgb <.6, 1, .7>
        }

    }
    // bottom box
    box {
        <-0.8,0,-6>,
        <2.2,5,-3>
        pigment {color <.9,.9,.9>}
        scale 0.99999

    }
}

// Place water near reference surface
union {
    // text
    text {
        ttf "cyrvetic.ttf" "Ideal Reference Surface" .03, 0
        pigment {color rgb <1, 1, .2>}
        finish { 
            reflection .25 
            specular 1
        }
        scale .25
        rotate <90,-90,0>
        translate <2.5,0.01,-5.8>
        
    }
     
    object {
        refsurf
    }
    object {
        wat
        rotate y*120
        translate <2,0.2,-5>   
    }
    object {
        wat
        rotate x*100
        translate <2,0.2,-4>   
    }
    object {
        wat
        rotate x*50
        translate <1.5,0.25,-4.1>   
    }
    object {
        wat
        rotate <30,0,80>
        translate <1.85,0.2,-5.1>   
    }
    object {
        wat
        rotate <0,0,0>
        translate <0,0.3,-3.3>   
    }
    object {
        wat
        rotate <10,20,50>
        translate <1.1,0.23,-5>   
    }
    object {
        wat
        rotate <-90,0,80>
        translate <1.8,0.22,-5.9>   
    }
    object {
        wat
        rotate <55,60,70>
        translate <0.9,0.28,-4.2>   
    }
    object {
        wat
        rotate <30,160,170>
        translate <.4,0.5,-4.5>   
    }
    object {
        wat
        rotate <30,160,10>
        translate <1.2,0.26,-5.7>   
    }
    
    translate <-0.9,0,1.7>
    

}
//*/


///*

// -------------- Declare Real surface
#declare realsurf=intersection{
    // top surface
    isosurface {
        surf
        pigment {
            bozo
            color_map {
                [ 0    rgb <.8, 0, 0> ]
                [ 0.4  rgb <.894,.55,.47> ]
                [ 0.5  rgb <.71,.5647,.725> ]
                [ 1.0  rgb <.2235,.2667,.73725> ]
            }
            scale .3 // a Little bit larger than the object
        }

    }
    // bottom box
    box {
        <-0.8,0,-6>,
        <2.2,5,-3>
        pigment {color <.9,.9,.9>}
        scale 0.99999

    }
}

// Unite real surface and water molecules
union {

    // text
    text {
        ttf "cyrvetic.ttf" "Real Surface" .03, 0
        pigment {color rgb <1, 1, .2>}
        finish { 
            reflection .25 
            specular 1
        }
        scale .28
        rotate <90,-90,0>
        translate <2.55,0.01,-5.5>
        
    }
    object {
        realsurf        
    }
    object {
        wat
        rotate y*70
        translate <2.1,0.21,-4.8>   
    }
    object {
        wat
        rotate x*100
        translate <2.15,0.2,-3.5>   
    }
    object {
        wat
        rotate x*50
        translate <1.5,0.25,-4.1>   
    }
    object {
        wat
        rotate <30,0,80>
        translate <1.85,0.2,-5.1>   
    }
    object {
        wat
        rotate <45,40,50>
        translate <-0.05,0.3,-3.6>   
    }
    object {
        wat
        rotate <10,20,90>
        translate <1.1,0.24,-4.8>   
    }
    object {
        wat
        rotate <-90,0,80>
        translate <1.3,0.22,-5.7>   
    }
    object {
        wat
        rotate <50,40,70>
        translate <0.3,0.24,-5.3>   
    }
    object {
        wat
        rotate <60,10,90>
        translate <0.5,0.25,-5.2>   
    }
    object {
        wat
        rotate <-90,0,80>
        translate <1.5,0.24,-5.5>   
    }
    object {
        wat
        rotate <-90,0,80>
        translate <-0.7,0.28,-4.8>   
    }
    object {
        wat
        rotate <-90,100,80>
        translate <-0.5,0.4,-4.4>   
    }
    object {
        wat
        rotate <0,60,70>
        translate <0.6,0.3,-4.2>   
    }
    object {
        wat
        rotate <0,60,70>
        translate <0.45,0.3,-4.5>   
    }
    object {
        wat
        rotate <70,60,-250>
        translate <1.2,0.4,-3.9>   
    }
    
    translate <-1.1,0,5.7>

}



//*/

