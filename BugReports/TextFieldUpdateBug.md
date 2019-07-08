Bug Report:

Object properties appear to be tied to text field in the Reworld editor. After changing an object's velocity in script, 
the object velocity should return to 0 after the object has landed back on the floor and stopped moving. However, the 
Velocity parameter does not actually update until you manually click on the object in the text field. This makes it very
difficult to rapidly update the part's velocity. 