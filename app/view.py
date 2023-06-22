import tkinter as tk
from tkinter import ttk


class View:
    def display(self, message):
        print(message)

    def __init__(self):#, root):
        pass
        #self.root = root
        #self.root.resizable(False, False)
        #self.root.title("Расписание рейсов")

    def ModifyForm(self, data):
        print(data)
        return

    def RegistrationForm(self, data):
        print(data)
        return


    # tab_data: {
    #   'tabs_name' : {
    #       'columns' : [],
    #       'data': []
    #   }
    # }
    def TabControl(self, tabs_data):
        print(tabs_data)
        return
        tab_control = ttk.Notebook(self.root)
        for tab_name in tabs_data:
            frame = ttk.Frame(tab_control)
            tab_control.add(frame, text=tab_name)
            headings = tabs_data[tab_name]['columns']

            # Создание DATAGRID для таблицы
            table_tree = ttk.Treeview( frame, columns=headings, show="headings")
            table_tree.grid(row=0, column=0, sticky="nsew")

            # Добавление строк
            for row in tabs_data[tab_name]['data']:
                table_tree.insert("", tk.END, values=row)

            # Растягивание столбцов на всю ширину окна
            for column in headings:
                table_tree.column(column,
                                  width=100,
                                  minwidth=100,
                                  stretch=tk.YES)

        # Отображение Tab-контрола
        tab_control.pack(expand=1, fill="both")
