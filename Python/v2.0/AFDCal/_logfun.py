def clearLog(self):
    """
    Clear log string
    """
    self.log = ''

def addLog(self, 
           logStr: str):
    """
    Add log
    """
    self.log += '\n'
    self.log += logStr

def dispLog(self):
    """
    Print log
    """
    print(self.log)
