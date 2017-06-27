#!/usr/bin/env python

def drop_inputs(df, todrop_file):
    if todrop_file is not None:
        todrop = [s.strip() for s in open(todrop_file, "r").readlines() if s[0] != "#"]
        
        return df.drop(todrop, level='input')

    return df

def rename_inputs(df):
    def rename(x):
        
        x = x.replace(".sym", "")
        x = x.replace("_adj", "")
        x = x.replace(".wgt32", "")
        return x

    ndx = df.index.names.index('input')
    df.index = df.index.set_levels(df.index.levels[ndx].map(rename), "input")

    return df


