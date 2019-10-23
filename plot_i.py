
import matplotlib
import matplotlib.pyplot as plt 


plt.style.use('bmh')


#set interactive mode
plt.ion()

fig = plt.figure(1)
ax = fig.add_subplot(111)



# Holds a specific cover group
class CGroup:
    def __init__(self, name, cycle,grade ):
        self.name = name
        self.XCycles=[]
        self.XCycles.append(cycle)
        self.YGrades=[]
        self.YGrades.append(grade)   
        self.line_Object= ax.plot(self.XCycles, self.YGrades,label=name)[-1]              
        self.firstMaxCycle=cycle
        self.firstMaxGrade=grade
    def add(self,cycle,grade):
        self.XCycles.append(cycle)
        self.YGrades.append(grade)
        if grade>self.firstMaxGrade:
            self.firstMaxGrade=grade
            self.firstMaxCycle=cycle           
        self.line_Object.set_xdata(self.XCycles)
        self.line_Object.set_ydata(self.YGrades)
        plt.legend(shadow=True)
        fig.canvas.draw()
      
#Holds all the data of all cover groups    
class CData:
    groupsList=[]
           
    def add (self,groupName,cycle,grade):
        found=0
        for group in self.groupsList:
            if groupName in group.name:
                group.add(cycle,grade)
                found=1
                break
        if found==0:
            obj=CGroup(groupName,cycle,grade)
            self.groupsList.append(obj)
      
    def drawFirstMaxGrade(self):
        for group in self.groupsList:
            left, right = plt.xlim()
            x=group.firstMaxCycle
            y=group.firstMaxGrade
            
            #draw arrow
            #ax.annotate("first\nmaximum\ngrade", xy=(x,y),
            #xytext=(right-50, 0.4),arrowprops=dict(facecolor='blue', shrink=0.05),)
            
            #mark the points on the plot
            plt.scatter(group.firstMaxCycle, group.firstMaxGrade,color=group.line_Object.get_color())
            
            #Add etxt next to the point    
            text='cycle:'+str(x)+'\ngrade:'+str(y)            
            plt.text(x+3, y-0.1, text, fontsize=9,  bbox=dict(boxstyle="round4",color=group.line_Object.get_color()))
                                                              #facecolor='wheat' ))
        

#Global data
myData=CData()
def addVal(groupName,cycle,grade):
    myData.add(groupName,cycle,grade)
    

def init_plot(numCycles):
    plt.xlabel('cycles') 
    plt.ylabel('grade')    
    plt.title('Grade over time')       
    plt.ylim(0,1)
    plt.xlim(0,numCycles)
   
def end_plot(): 
    plt.ioff();
    myData.drawFirstMaxGrade();
    plt.show();
   

#uncomment the following line to run this script with simpel exampel
#init_plot(300)
#addVal("xx",1,0)
#addVal("yy",1,0)
#addVal("xx",50,0.3)
#addVal("yy",60,0.4)
#addVal("xx",100,0.8)
#addVal("xx",120,0.8)
#addVal("xx",180,0.8)
#addVal("yy",200,0.9)
#addVal("yy",210,0.9)
#addVal("yy",290,0.9)
#end_plot()
