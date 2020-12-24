with open("changelog.md", "r") as file:
    a = 1
    li = []
    fake = []
    body = ""
    for i in file:
        a+=1
        if i.startswith("#"):
            li.append(a)
        if len(li) == 1:
            fake.append(i)
#           print(i, end="")
    body = body.join(fake)
    # Deprecated
    #print(f"::set-env name=BODY::{body}")
    print(f"::set-output name=BODY::{body}")
