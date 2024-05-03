import pandas as pd
import numpy as np
import glob
import os

# define your current path (where RAW files are) and where you'd like to save modified files
old_path = os.getcwd()
new_path = r'/lustre03/project/rpp-markpb68/m3group/Haqqee/data/ABET/Batch_4/Renamed/'

# do you want to merge the session info and ABET data in one file, or save them separately?

merge = True

########################################################################################################################################

# collect all appropriate csv files
all_files = glob.glob(old_path + "/CI*.csv")

# loop through each RAW file and return modified file, renamed
for file in all_files:

    rowcheck = pd.read_csv(file,error_bad_lines=False, warn_bad_lines=False)
    fullcsv = pd.read_csv(file,error_bad_lines=False, warn_bad_lines=False, header=None, delimiter=',', names=range(17))

    sessionInfo = pd.read_csv(file, nrows=rowcheck.shape[0]-1)
    data = pd.read_csv(file, skiprows=rowcheck.shape[0], header=1)

    # create a small function for finding things based on labels in the "Name" column
    find_label = lambda data_label : sessionInfo.iloc[np.where(sessionInfo['Name']==data_label)[0][0],1]

    # for other labels of interest, use the function "find_label" (created above) to find the session label of interest
    animalID = find_label('Animal ID')
    database = find_label('Database')
    date = find_label('Schedule_Start_Time')[0:10]
    time = find_label('Date/Time')[-8:]
    sessionID = find_label('SessionId')
    task = find_label('Schedule')

    # replace blanks with zeroes
    data['Arg1_Value'].fillna(0, inplace=True)
    data['Arg2_Value'].fillna(0, inplace=True)
    data['Arg3_Value'].fillna(0, inplace=True)
    data['Arg4_Value'].fillna(0, inplace=True)
    data['Arg5_Value'].fillna(0, inplace=True)

    # create new name to save data as
    new_name = animalID+"_"+date+"_"+sessionID+"_abet.csv"
    session_name = animalID+"_"+date+"_"+sessionID+"_session.csv"
    new_name = new_name.replace('-','_')
    session_name = session_name.replace('-','_')

    output_file = os.path.join(new_path,new_name)
    session_file = os.path.join(new_path,session_name)

    # Use this function to search for any files which match your filename
    files_present = glob.glob(output_file)

    old_name = file.split('/')[-1]
    # if no matching files, write to csv, if there are matching files, print statement
    if not files_present:
        if data['Evnt_Time'].values[-1]>200: # this is to filter out short, accidental recording
            if merge:
                fullcsv.to_csv(output_file, index=False)
                print(f'Saved {old_name} as {new_name} with session info')
            else:
                data.to_csv(output_file, index=False)
                print(f'Saved {old_name} as {new_name}')
                sessionInfo.to_csv(session_file, index=False)
                print(f'Saved {old_name} session as {session_name}')
        else:
            print(f'SKIPPED: {old_name} is very short. Flagged as accidental recording')
    else:
        #pass
        print(f'Checked: {new_name} ; it already exists!')

print('Done!')
