#!/usr/bin/env python3

import sys


def is_alphanumeric(x):
    return 'a' <= x <= 'z' or 'A' <= x <= 'Z' or '0' <= x <= '9'

class Alphanum:
    def __init__(self, char):
        self.char = char

    def __repr__(self):
        return 'Alphanum \'{}\''.format(self.char)

class Xor:
    def __init__(self, char):
        self.char = char

    def __repr__(self):
        return 'Xor \'{}\''.format(self.char)
    
class Not:
    def __init__(self):
        pass

    def __repr__(self):
        return 'Not'

def find_all_patches():
    ans = []
    ans.extend(range(ord('0'), ord('9') + 1))
    ans.extend(range(ord('A'), ord('Z') + 1))
    ans.extend(range(ord('a'), ord('z') + 1))

    steps = [None for i in range(256)]
    for i in range(128):
        if is_alphanumeric(chr(i)):
            steps[i] = [Alphanum(chr(i))]
        else:
            # This is just so I don't have to do math.
            for j in ans:
                if i ^ j in ans:
                    steps[i] = [Alphanum(chr(j)), Xor(chr(i ^ j))]
                    break
            else:
                raise Exception
    for i in range(128, 256):
        i_not = i ^ 255
        for j in ans:
            if i_not ^ j in ans:
                steps[i] = [Alphanum(chr(j)), Xor(chr(i_not ^ j)), Not()]
                break
        else:
            raise Exception
            
    return steps

def make_alphanumeric_pseudo_assembly_code(patches, inp):
    xor_instr_length = 3
    not_instr_length = 2

    def instr_len(p):
        if isinstance(p, Xor):
            return xor_instr_length
        elif isinstance(p, Not):
            return not_instr_length
        else:
            raise Exception

    length_to_db = []
    length_temp = 0
    for i in inp[::-1]:
        ps = patches[i][1:]
        length_temp += sum(instr_len(p) for p in ps)
        length_to_db.append(length_temp)
    length_to_db = length_to_db[::-1]

    length_to_byte = [l + offset for l, offset in zip(length_to_db, range(len(inp)))]

    lines = []
    
    for i, ltb in zip(inp, length_to_byte):
        ps = patches[i][1:]
        for p in ps:
            if isinstance(p, Xor):
                lines.append('xor [esi+{}], \'{}\''.format(ltb, p.char))
            elif isinstance(p, Not):
                lines.append('not [esi+{}]'.format(ltb))
            else:
                raise Exception

    lines.append('db \'{}\''.format(''.join(patches[i][0].char for i in inp)))

    return ''.join(line + '\n' for line in lines)

if __name__ == '__main__':
    patches = find_all_patches()
    inp_file = sys.argv[1]
    with open(inp_file, 'rb') as f:
        inp = f.read()
    print(make_alphanumeric_pseudo_assembly_code(patches, inp), end='')
