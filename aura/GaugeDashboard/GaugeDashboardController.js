({
    gaugeSetup : function(component, event, helper) {
       
        var opts = {
            angle: -0.2, // The span of the gauge arc
            lineWidth: 0.2, // The line thickness
            radiusScale: 1, // Relative radius
            pointer: {
                length: 0.6, // // Relative to gauge radius
                strokeWidth: 0.035, // The thickness
                color: '#000000' // Fill color
            },
            staticZones: [
                {strokeStyle: "#30B32D", min: 0, max: 50}, // Green 
                {strokeStyle: "#FFDD00", min: 50, max: 75}, // Yellow
                {strokeStyle: "#F03E3E", min: 75, max: 100}, // Red
            ],
            limitMax: false,     
            limitMin: false,     
            colorStart: '#6FADCF',   
            colorStop: '#8FC0DA',   
            strokeColor: '#E0E0E0',  
            generateGradient: true,
            highDpiSupport: true,    
            
        };
        
        // gauge to display MainScore Score
        var target = document.getElementById(component.get("v.canvasId")); 
        var gauge = new Gauge(target).setOptions(opts); 
        gauge.maxValue = 100; 
        gauge.setMinValue(0);  
        gauge.animationSpeed = 32; 
        gauge.set(component.get("v.componentValue")); 
         
    }
})