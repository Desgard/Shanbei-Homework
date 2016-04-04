def run():
    print 'input file:'
    input = raw_input()
    print 'output file:'
    output = raw_input()
    f = open(input)
    f2 = open(output, 'w')
    try:
        file_all = f.readlines()
        for line in file_all:
           #print line
           a = ''
           b = ''
           ok = 1
           for i in line:
               #print i
               if i == '' or i == '\t' or i == '\n':
                   ok = 0
                   continue
               if ok == 1:
                   a += i
               elif ok == 0:
                   b += i
           f2.write('[open addObject: @"INSERT INTO WORD(WORD, WORDLEVEL) VALUES(\'' + a + '\', \'' + b +'\')"];\n')
    finally:
        f.close()
        f2.close()
	

if __name__ == '__main__':
    run()
    #s = 'dasdsa  dasda'
    #print s.strip()
    #print s[0], s[1]
