
class Controller:
    def __init__(self, view):
        self.view = view
#        self.buttonAdd["command"] = self.addData
#        self.buttonDel["command"] = self.delData
#        self.buttonUpd["command"] = self.updData

    def handle_request(self, request):
        self.view.display(request)
