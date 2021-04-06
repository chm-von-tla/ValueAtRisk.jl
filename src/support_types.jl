"""
    ARCHSpec

A specification for the GARCH dynamics of an appropriate model
"""
struct ARCHSpec
    volspec
    dist
    meanspec
    function ARCHSpec(volspec; dist=StdNormal, meanspec=Intercept)
        new(volspec,dist,meanspec)
    end
end
function Base.show(io::IO,asp::ARCHSpec)
    meanspec = "$(asp.meanspec)"
    volspec = "$(asp.volspec)"
    str_lst = [meanspec, volspec]


    for i in eachindex(str_lst)
        if (m = match(r"(?<start>.*)(?<ignore>,T} where T)",str_lst[i]); m != nothing)
            str_lst[i] = m["start"] * "}"
        end
    end
    print(io, "$(str_lst[1])-$(str_lst[2]) model with $(asp.dist) innovations")
end

"""
    shortname(asp::ARCHSpec)

Print a short description for the ARCHSpec given. Orders of ARCH models and mean specifications
are ignored
"""
function shortname(asp::ARCHSpec)
    #### WARNING: lots of assumptions being made
    longname = "$(asp)"
    m = match(Regex(raw"(?<meanspec>.*)-(?<vtype>[ET])GARCH{(?<vdigit>\d).*"),longname)
    local volspec
    if m["vtype"] == "E"
        volspec = "EGARCH"
    elseif m["vtype"] == "T" && m["vdigit"] == "0"
        volspec = "GARCH"
    elseif m["vtype"] == "T" && m["vdigit"] == "1"
        volspec = "TGARCH"
    else
        throw("shortname: unhandled ARCH spec type $longname")
    end
    "$(volspec)-$(asp.dist)"
end
