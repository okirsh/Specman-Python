<'

//***COV: In order to get coverage information you need inherint user_cover_struct and override end_group() to get the information of the group.
//(there are also methods for items and buckets).
struct my_cover_struct like user_cover_struct {

    //***PYTHON: the first line defines a method in Python (file name and method name). The enxt line
    //defines its singnature. 
    @import_python(module_name="plot_i", python_name="addVal")
    addVal(groupName:string, cycle:int,grade:real) is imported; ;

     // get the group grade as a number between 0 to 1 and send to python    
    !cur_group_grade:real;
   
    end_group() is also {
        cur_group_grade = group_grade/100000000; 

        //***PYTHON: send the data to python
        addVal(group_name,sys.time, cur_group_grade);              
 
    }
    
};



extend sys {

    //***PYTHON: the first line defines a method in Python (file name and method name). The enxt line
    //defines its singnature. 
    @import_python(module_name="plot_i", python_name="init_plot")
    init_plot(numCycles:int) is imported; ;
 
     //***PYTHON: the first line defines a method in Python (name and location). The enxt line
    //defines its singnature. 
    @import_python(module_name="plot_i", python_name="end_plot")
    end_plot() is imported; 
  
  
};


type packet_protocol : [ETHERNET, IEEE, ATM];

struct packet{
   
    len : uint(bits:4);      
  
    data : list of byte; 
    keep data.size() == len; 
    
    pkt_type: packet_protocol;

    event packet_cover;
    cover packet_cover is {
        item len;
        item pkt_type;
    };
    
};




extend sys {    
    inst : packet;
    
    //***COV: instance of the struct that wil hold the coverage infomration (being defined at the beginning of the file) 
    !cover_info : my_cover_struct;
    
    numCycles:int;
    keep numCycles==900;
    
    
    run() is also {
        start scenario();
    };
    scenario() @any is {
        raise_objection(TEST_DONE);
 

        //***PYTHON: initialize the plot in python
        init_plot(numCycles);
        
 
       
        while(sys.time<numCycles)
        {
             
            gen inst;
            emit inst.packet_cover;
            cover_info = new;
            
            ///***COV: get the current coverage information for packet
            var num_items := cover_info.scan_cover("packet.packet_cover");
                        
            
            //do....
            wait [9] * cycle;
        
        };

        //***PYTHON-Finish the plot in python
        end_plot();

        
        drop_objection(TEST_DONE);
    };    
};

            

type power_t         : [OFF, STAND_BY, ON];
type state_machine_t : [IDLE, ADDRESS, DATA]; 
struct state_machine_s like any_sequence_item {
    power : power_t;
    fsm  : state_machine_t;
    
    keep soft power == select {
        10 : STAND_BY;
        100 : ON;
    };
    keep soft fsm == select {
        100 : IDLE;
        5  : DATA;
    };
    
    event state_machine_cover;
    
    cover state_machine_cover is {
        item power;
        item fsm;
        cross power, fsm;
    };
};

// the state machine generaiton controlled with sequences

sequence controller_seq using item = state_machine_s, created_driver = controller_driver;

extend controller_driver {
    event clock is only @sys.any;
    
    run() is also {
        start dummy_bfm();
    };
    dummy_bfm() @clock is {
        var ctrl : state_machine_s;
        while TRUE {
            ctrl = get_next_item();
            emit ctrl.state_machine_cover;
            wait [10] * cycle;
            
            
            //***COV: get the current coverage infomration for state_machine
            compute sys.cover_info.scan_cover("state_machine_s.state_machine_cover");
            emit item_done;
        };
    };
};

extend controller_seq {
    !ctrl : state_machine_s;
};

extend controller_seq_kind : [ARB, INIT, MODE_0, CONFIG ];

extend MAIN controller_seq {
    !seq : controller_seq;
    body() @driver.clock is only {
        for i from 0 to 7 {
            do seq keeping {it.kind != ARB;};
        };
         for i from 0 to 7 {
            do seq;
        };
    };
};
extend INIT controller_seq {
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [1] * cycle;
            do ctrl;
        };
    };
};
extend MODE_0 controller_seq {
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [2] * cycle;
            do ctrl;
        };
    };
};
extend CONFIG controller_seq {
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [1] * cycle;
            do ctrl keeping {.power == ON};
        };
    };
};

extend ARB controller_seq {
    keep soft ctrl.power == select {
        30 : OFF;
        30 : STAND_BY;
        30 : ON;
    };
    keep soft ctrl.fsm == select {
        30 : IDLE;
        30 : ADDRESS;
        30 : DATA;
    };
    
    body() @driver.clock is only {
        for i from 0 to 10 {
            wait [3] * cycle;
            do ctrl;
        };
    };
};


extend sys {
    controller_driver is instance;
};

'>
 