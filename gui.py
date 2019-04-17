# imports
import tkinter as tk
from tkinter import ttk
from tkinter import *
import os

# Create instance
window = tk.Tk()
# Add a title
window.title("Senior Project")
window.geometry("270x270") # size of the window width & height

# Create Tab Control
tabControl = ttk.Notebook(window)

# Create a tab
tab1 = ttk.Frame(tabControl)
# Add the tab
tabControl.add(tab1, text='Game')
# Pack to make visible
tabControl.pack()

tab2 = ttk.Frame(tabControl)
tabControl.add(tab2, text='RDS')
tabControl.pack(expand=1, fill="both")

# this is placed in 0 0
ttk.Label(tab1, text = "Access Key:").grid(row=0,padx=10,pady=10)
ttk.Label(tab2, text = "Access Key:").grid(row=0,padx=10,pady=10)
theAccessKey = tk.StringVar()
# 'Entry' is used to display the input-field
# this is placed in 0 1
ttk.Entry(tab1, textvariable=theAccessKey).grid(row = 0, column = 1)
ttk.Entry(tab2, textvariable=theAccessKey).grid(row = 0, column = 1)
# this is placed in 1 0
ttk.Label(tab1, text = "Secret Key:").grid(row=1,padx=10,pady=10)
ttk.Label(tab2, text = "Secret Key:").grid(row=1,padx=10,pady=10)
theSecretKey = tk.StringVar()
# this is placed in 1 1
ttk.Entry(tab1, textvariable=theSecretKey).grid(row = 1, column = 1)
ttk.Entry(tab2, textvariable=theSecretKey).grid(row = 1, column = 1)

ttk.Label(tab1, text = "Instance Type:").grid(row=2,padx=10,pady=10)
theInstanceType = tk.StringVar()
InstanceCombo = ttk.Combobox(tab1,
                            values=[
                                    "g2.2xlarge",
                                    "g3.4xlarge"],
                            state="readonly",
                            textvariable=theInstanceType).grid(row=2, column=1)
#InstanceCombo.current(0)

ttk.Label(tab1, text = "Choose Game:").grid(row=3,padx=10,pady=10)
theGame = tk.StringVar()
GameCombo = ttk.Combobox(tab1,
                            values=[
                                    "Snake",
                                    "The Witcher 3: Wild Hunt"],
                            state="readonly",
                            textvariable=theGame).grid(row=3, column=1)
#GameCombo.current(0)

ttk.Label(tab1, text = "Choose Action:").grid(row=4,padx=10,pady=10)
theGameAction = tk.StringVar()
GameActionCombo = ttk.Combobox(tab1,
                            values=[
                                    "Choose Action",
                                    "Start",
                                    "Delete"],
                            state="readonly",
                            textvariable=theGameAction).grid(row=4, column=1)
#GameActionCombo.current(0)

def callit():
    ak = theAccessKey.get()
    sk = theSecretKey.get()
    it = theInstanceType.get()
    g = theGame.get()
    ga = theGameAction.get()
    rdsp = theRDSpassword.get()
    print("Access Key: ", ak)
    print("Secret Key: ", sk)
    print("Instance Type: ", it)
    print("Game: ", g)
    print("Game Action: ", ga)
    print("RDS Password: ", rdsp)
    if(ga == 'Start'):
        os.system('python build.py "%s" "%s" "%s"' % (rdsp, ak, sk))

b2 = Button(tab1, text="Go", command=callit).grid(row=5, column=1)




ttk.Label(tab2, text = "RDS Username:").grid(row=3,padx=10,pady=10)
theRDSusername = tk.StringVar()
ttk.Entry(tab2, textvariable=theRDSusername).grid(row = 3, column = 1)
ttk.Label(tab2, text = "RDS Password:").grid(row=4,padx=10,pady=10)
theRDSpassword = tk.StringVar()
ttk.Entry(tab2, textvariable=theRDSpassword).grid(columnspan = 20, row = 4, column = 1)
ttk.Label(tab2, text = "Choose Action:").grid(row=5,padx=10,pady=10)
theRDSaction = tk.StringVar()
RDSActionCombo = ttk.Combobox(tab2,
                            values=[
                                    "Choose Action",
                                    "Create",
                                    "Destroy"],
                            state="readonly",
                            width=20,
                            textvariable=theRDSaction).grid(row=5, column=1)
#RDSActionCombo.current(0)

def callback():
    ak = theAccessKey.get()
    sk = theSecretKey.get()
    rdsu = theRDSusername.get()
    rdsp = theRDSpassword.get()
    rdsa = theRDSaction.get()
    print("Access Key: ", ak)
    print("Secret Key: ", sk)
    print("RDS Username: ", rdsu)
    print("RDS Password: ", rdsp)
    print("RDS Action: ", rdsa)
    if(rdsa == 'Create'):
        os.system('bash ./setup.sh "%s" "%s" "%s" "%s"' % (rdsu, rdsp, ak, sk))

b = Button(tab2, text="Go", command=callback).grid(row=6, column=1)


#Calling Main() to start GUI
window.mainloop()
