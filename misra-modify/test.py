import re

def check_macro(code):
    regex = r"#define\s+\w+\s*\((\w+)\)"
    macros = re.findall(regex, code)
    for macro in macros:
        regex = r"\b{}\b".format(macro)
        if re.search(regex, code) and not re.search(r"\({}\)".format(macro), code):
            return False
    return True

code1 = """
#define pabs2(x) ((x) >= 0 ? (x) : -(x))
int main() {
    int a = 5;
    int b = pabs(a);
    int c = pabs2(a);
    return 0;
}
"""

code2 = """
#define pabs(x) x >= 0 ? x : -x
int main() {
    int a = 5;
    int b = pabs(a);
    return 0;
}
"""

print(check_macro(code1))  # Output: True
print(check_macro(code2))  # Output: False
