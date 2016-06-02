#!/usr/bin/env python3

import sys


def is_alphanumeric(x):
    return 'a' <= x <= 'z' or 'A' <= x <= 'Z' or '0' <= x <= '9'

def only_alphanumeric_bytes(xs):
    return all(is_alphanumeric(chr(x)) for x in xs)

def xor_patch_number(n):
    assert 0 <= n <= 255

    patches = []

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
            
    print(steps)

if __name__ == '__main__':
    find_all_patches()
