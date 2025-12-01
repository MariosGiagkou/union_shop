import re

def main():
    with open('coverage/lcov.info', 'r') as f:
        data = f.read()
    
    files = {}
    for block in data.split('end_of_record'):
        sf_match = re.search(r'SF:(.+)', block)
        if sf_match:
            filepath = sf_match.group(1)
            # Only process lib files
            if 'lib/' in filepath or 'lib\\' in filepath:
                lf = re.search(r'LF:(\d+)', block)
                lh = re.search(r'LH:(\d+)', block)
                if lf and lh:
                    lines_found = int(lf.group(1))
                    lines_hit = int(lh.group(1))
                    if lines_found > 0:
                        percentage = (lines_hit / lines_found) * 100
                        files[filepath] = {
                            'percentage': percentage,
                            'hit': lines_hit,
                            'total': lines_found
                        }
    
    # Sort by percentage
    sorted_files = sorted(files.items(), key=lambda x: x[1]['percentage'])
    
    print("\n" + "=" * 80)
    print("FINAL COVERAGE REPORT")
    print("=" * 80)
    
    below_50 = []
    above_50 = []
    
    for filepath, data in sorted_files:
        pct = data['percentage']
        hit = data['hit']
        total = data['total']
        filename = filepath.split('\\')[-1] if '\\' in filepath else filepath.split('/')[-1]
        
        if pct < 50:
            below_50.append((filename, pct, hit, total))
        else:
            above_50.append((filename, pct, hit, total))
    
    if below_50:
        print(f"\n❌ FILES BELOW 50% ({len(below_50)} files):\n")
        for filename, pct, hit, total in below_50:
            print(f"   {pct:5.1f}% ({hit:3}/{total:3}) - {filename}")
    
    print(f"\n✅ FILES ABOVE 50% ({len(above_50)} files):\n")
    for filename, pct, hit, total in above_50[:10]:  # Show first 10
        print(f"   {pct:5.1f}% ({hit:3}/{total:3}) - {filename}")
    if len(above_50) > 10:
        print(f"   ... and {len(above_50) - 10} more files")
    
    print("\n" + "=" * 80)
    if below_50:
        print(f"RESULT: {len(below_50)} file(s) still need work")
    else:
        print("🎉 SUCCESS: ALL FILES HAVE >= 50% COVERAGE!")
    print("=" * 80 + "\n")
    
    return len(below_50)

if __name__ == '__main__':
    exit(main())
