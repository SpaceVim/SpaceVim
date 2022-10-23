if x > 2:
    #: E111:2
  hello(x)
if True:
    #: E111:5
     print
    #: E111:6
      # 
    #: E111:2
  # what
    # Comment is fine
# Comment is also fine

if False:
    pass
print
print
#: E903:0
    print
mimetype = 'application/x-directory'
#: E111:5
     # 'httpd/unix-directory'
create_date = False


def start(self):
    # foo
    #: E111:8
        # bar
    if True:  # Hello
        self.master.start()  # Comment
        # try:
        #: E111:12
            # self.master.start()
        # except MasterExit:
        #: E111:12
            # self.shutdown()
        # finally:
        #: E111:12
            # sys.exit()
    # Dedent to the first level
    #: E111:6
      # error
# Dedent to the base level
#: E111:2
  # Also wrongly indented.
# Indent is correct.


def start(self):  # Correct comment
    if True:
        #: E111:0
#       try:
        #: E111:0
#           self.master.start()
        #: E111:0
#       except MasterExit:
        #: E111:0
#           self.shutdown()
        self.master.start()  # comment
