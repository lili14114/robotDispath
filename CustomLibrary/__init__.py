from CustomLibrary.playloads import PlayLoads
from CustomLibrary.mytools import MyTools
from CustomLibrary.filetools import FileTools
__version__ = '0.1'
class CustomLibrary(PlayLoads,MyTools,FileTools):
    """ 这里也可以装 x 的写上我们创建的 CustomLibrary 如何如何。
    """
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
  