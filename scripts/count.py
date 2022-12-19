x = input("which file?\n")
f = open(f"./rtl/datamemory/{x}.mem","r")
o = open(f"./rtl/datamemory/predicted/{x}.mem","w")
out = ""
i = 0
x = 0
max = 200
count = 0
dict = {}
array = "\n"
while count != max and array[-1:] == "\n":
    array = f.readline()
    x = len(array) - 3
    while count != max and x >= 0:
        num = hex(int(array[x:x+2],16))
        if num not in dict: dict[num] = 1
        else: dict[num] += 1
        count = dict[num]
        x -= 2
    i += 1
for i in range(16):
    line =""
    for j in range(15,-1,-1):
        num = hex(j+i*16)
        if num not in dict: line += "00"
        else: line += f"{dict[num]:02X}"
    out += line.lower() + "\n"
o.write(out)
o.close()
f.close()