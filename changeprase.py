with open("changelog.md", "r") as file:
    a = 1
    li = []
    fake = []
    body = ""
    for i in file:
        a+=1
        if i.startswith("#"):
            li.append(a)
        if len(li) == 1 and not i.isspace():
            fake.append(i)
    body = body.join(fake)
    # Deprecated
    #print(f"::set-env name=BODY::{body}")
    print(f"::set-output name=BODY::{body.strip()}")
