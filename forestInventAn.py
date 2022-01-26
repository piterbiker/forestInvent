import datetime
import os, re
import time
import sqlite3
import sys
from katalogi import kat, podkat, folder
from katalogi import encin
from ftplib import FTP
from connectMySql import piterbikHost

import androidhelper

droid = androidhelper.Android()

SZERPOLA = 100

pliksql = 'inwent.sql'        # plik skryptu SQL tworzenia struktury bazy
pliksqlite = 'inwent.sqlite'  # plik wynikowy bazy danych
        
filename = os.path.join(kat, pliksqlite)
filename2 = os.path.join(kat, pliksql)

def mainMenu(topic, methodList):
    droid.dialogCreateAlert(topic)
    droid.dialogSetItems(methodList)
    droid.dialogShow()
    nika=droid.dialogGetResponse().result['item']

    droid.clearContextMenu()
    droid.clearOptionsMenu()

    return nika


def numberItem(topic, additional, default=''):
    droid.dialogCreateInput(topic, additional, default, 'number')
    droid.dialogSetPositiveButtonText('OK')
    droid.dialogShow()

    wartosc=int(droid.dialogGetResponse().result['value'])
    droid.dialogDismiss()

    return wartosc


def mainAppMenu(db):
    menuArr = [
        'Pomiar+',
        'Drzewo+',
        'Drzewo-',
        'Zinwentaryzowano',
        'FTP wysylka', 
        'Wyjscie'
    ]

    wybor = mainMenu('Akcja:', menuArr)
    if wybor == 0:
        add_pomiar(db)
    elif wybor == 1:
            add_tree(db)
    elif wybor == 2:
            remove_tree(db)
    elif wybor == 3:
            lista_punktow(db)
    elif wybor == 4:
            ftp_operation()
    elif wybor == 5:
            quit(db)


def main():

    # otwieranie pliku skryptu z zapytaniami
    fd = open(filename2, 'r', encoding=encin)
    sqlFile = fd.read()
    fd.close()

    # rozdzielenie pojedynczych zapytan z pliku
    utworzenie = sqlFile.split(';\n')

    db = None
    try:
        # wywolanie funkcji polaczenia z parametrami: plik bazy oraz zapytania tworzace strukture
        db = connect(filename, utworzenie)
    except Exception as p:
            print ('Blad: ', p)
    else:
        mainAppMenu(db)

    finally:
        if db is not None:
            db.close()

# funckcja polaczenia z baza i tworzaca strukture bazy
def connect(filename, utworzenie):
    create = not os.path.exists(filename)
    db = sqlite3.connect(filename)

    cur = db.cursor()

    rs = cur.execute('SELECT sqlite_version()')    
    for row in rs:
        msg = "### SQLite: %s ###" % (row[0])
        print (msg)

    print (SZERPOLA * '#')

    # tworzenie struktury bazy, jesli plik nie istnieje
    if create:
        cursor = db.cursor()
        for command in utworzenie:
            try:
                if re.match('--', command):  # ignoruj linie z komentarzem SQL
                    print('Komentarz:' + command[0:30] + '\n\tpominieto\n')
                    continue
                else:
                    cursor.execute(command)     # wykonaj 1 linie zapytania
            except sqlite3.OperationalError as msgerr:
                print ('Polecenie odrzucone: ', msgerr)
            else:
                print('Zapytanie:' + command[0:50] + '\n\twykonano z powodzeniem\n')
        db.commit()
    return db


def add_pomiar(db):

    dzialka = droid.dialogGetInput('Numer dzialki', 'Pelny numer TERYT').result
    lokalizacja = droid.dialogGetInput('Lokalizacja', 'Miejscowosc').result

    getOzuQuery = "select ENUMERATION, DESCRIPTION from EGB_OZUTYPES order by ENUMERATION"
    ozuArr = find_record(db, getOzuQuery)

    ozuArrNew = []
    for ozu in ozuArr:
        ozuArrNew.append('{}: {}'.format(*ozu))

    ozu = mainMenu('Oznaczenie uzytku', ozuArrNew)
    ozuz = ozuArr[ozu][0]

    cursor = db.cursor()
    sql = ("""insert into INW_PJ_POMIARY (ID, NUMER_DZ, LOKALIZACJA, OZU, CREATED_DATE) 
            VALUES(NULL, '%s', '%s', '%s', CURRENT_DATE);""") % \
            (dzialka, lokalizacja, ozuz)

    try:
        cursor.execute(sql)
        db.commit()

    except Exception as p:
        droid.dialogCreateAlert('Blad dodania rekordu',p)

    else:
        droid.dialogCreateAlert('Dodano pomiar dla dzialki', '{} ({})'.format(dzialka, lokalizacja))

    finally:
        droid.dialogShow()
        time.sleep(2)
        mainAppMenu(db)


def add_tree(db):
    getPomiaryQuery = "select ID, NUMER_DZ, LOKALIZACJA from INW_PJ_POMIARY where CREATED_DATE=CURRENT_DATE order by ID desc"
    getGatunkiQuery = "select SKROT, NAZWA_PL, NAZWA_LAC from INW_PJ_GATUNKI order by IGLASTE desc, SKROT"

    # domyslne wartosci
    wysoko = '0'

    # Pomiary
    pomiarArr = find_record(db, getPomiaryQuery)

    pomiarArrNew = []
    for pomiar in pomiarArr:
        pomiarArrNew.append('[{}]: {}, {}'.format(*pomiar))

    pomiar = mainMenu('Pomiar', pomiarArrNew)
    pomiarz = pomiarArr[pomiar][0]
    if not pomiarz:
        return
    
    # Gatunki
    gatunkiArr = find_record(db, getGatunkiQuery)

    gatunkiArrNew = []
    for gatunek in gatunkiArr:
        gatunkiArrNew.append('[{}]: {}, {}'.format(*gatunek))

    gatunek = mainMenu('Gatunek drzewa', gatunkiArrNew)
    gatunekz = gatunkiArr[gatunek][0]
    if not gatunekz:
        return

    licznik=numberItem('Liczba drzew', 'dla wybranego gatunku', '10')

    for i in range(1, licznik+1):

        lokalizacjaArr = getPosition()

        jeden = float(lokalizacjaArr[0]) 
        cztery = float(lokalizacjaArr[1])  
        punkt = (lokalizacjaArr[0] + ' ' + lokalizacjaArr[1])

        nrDrzewa = 'Drzewo {}: {}'.format(i, punkt)
        srednica130 = numberItem(nrDrzewa, 'Srednica 130 [cm]')
        srednica10 = numberItem(nrDrzewa, 'Srednica 10 [cm]')
        wysokosc = numberItem(nrDrzewa, 'Wysokosc [m]', wysoko)
        obwod130 = numberItem(nrDrzewa, 'Obwod 130 [cm]', wysoko)
        obwod10 = numberItem(nrDrzewa, 'Obwod 10 [cm]', wysoko)
 
        cursor = db.cursor()

        sql = ("""insert into INW_PJ_DRZEWA (ID, POMIAR_ID, GATUNEK, SREDNICA_130, SREDNICA_10, WYSOKOSC, OBWOD_130, OBWOD_10, LOC_X, LOC_Y) 
                    values (NULL, %d, '%s', %d, %d, %d, %d, %d, %f, %f);""") % \
                (pomiarz, gatunekz, srednica130, srednica10, wysokosc, obwod130, obwod10, jeden, cztery)

        try:
            cursor.execute(sql)
            db.commit()
        except Exception as p:
            droid.dialogCreateAlert('Blad dodania rekordu', p)

        else:
            droid.dialogCreateAlert('Dodano drzewo', '{} ({})'.format(gatunekz, srednica130))
        
        finally:
            droid.dialogShow()
            time.sleep(2)
        
    mainAppMenu(db)
 

def remove_tree(db):
    getTreesQuery = "select ID, GATUNEK, SREDNICA_130 from INW_PJ_DRZEWA order by ID desc limit 5" 

    pomiarDelArr = find_record(db, getTreesQuery)

    pomiarDelArrNew = []
    for pomiar in pomiarDelArr:
        pomiarDelArrNew.append('[{}]: {}, {}'.format(*pomiar))

    pomiar = mainMenu('Pomiar', pomiarDelArrNew)
    identity = int(pomiarDelArr[pomiar][0])

    droid.dialogCreateAlert('Usunac {0}?'.format(identity))
    droid.dialogSetPositiveButtonText('TAK')
    droid.dialogSetNegativeButtonText('Nie')
    droid.dialogShow()

    response=droid.dialogGetResponse().result['which']
    droid.dialogDismiss()
    droid.clearContextMenu()

    if response=="positive":
            
        cursor = db.cursor()
        cursor.execute("delete from INW_PJ_DRZEWA where ID=?", (identity, ))
        db.commit()

    mainAppMenu(db)

    
def find_record(db, sqlQuery):
    cursor = db.cursor()
    cursor.execute(sqlQuery)

    records = cursor.fetchall()
    return records


def pomiary_count(db):
    cursor = db.cursor()
    cursor.execute("SELECT COUNT(*) FROM INW_PJ_POMIARY where CREATED_DATE=CURRENT_DATE")
    return cursor.fetchone()[0]


# TODO
def lista_punktow(db):
    cursor = db.cursor()
    sql = ("select NUMER_DZ, LOKALIZACJA, UZYTEK, GATUNEK, SREDNICA_130, SREDNICA_10, WKT from INW_PJ_POMIARY_DEV_V where CREATED_DATE=CURRENT_DATE order by NUMER_DZ, GATUNEK")
    cursor.execute(sql)
    records = cursor.fetchall()

    droid.dialogCreateAlert('Dodane pomiary drzew')
    droid.dialogSetItems(records)
    droid.dialogSetPositiveButtonText('OK')
    droid.dialogShow()

    response=droid.dialogGetResponse().result['which']
    if response=="positive":
        droid.dialogDismiss()
        droid.clearContextMenu()

        mainAppMenu(db)


def quit(db):
    if db is not None:
        count = pomiary_count(db)
        db.commit()
        db.close()
        droid.dialogCreateAlert('{0} Rekordy (pomiary)'.format(count))
        droid.dialogShow()
        time.sleep(2)
    sys.exit()


def ftp_conn():
    ftp = None
    try:
        ftp = FTP(piterbikHost)
        loginFtp = 'lokal@{}'.format(piterbikHost) #atolgeo
        droid.dialogGetPassword('Haslo FTP')
        passFtp=droid.dialogGetResponse().result['value']
        ftp.login(loginFtp, passFtp)
    except Exception as g:
        droid.dialogCreateAlert('Blad polaczenia FTP', g)
    else:
        return ftp


def ftp_operation():
    openSqLiteOut = open(filename, "rb")
    ftp = None
    try:
        ftp = ftp_conn()
        wysylka = ftp.storbinary('STOR ' + pliksqlite, openSqLiteOut)
    except Exception as g:
        droid.dialogCreateAlert('Blad wysylki FTP', g)
    else:
        droid.dialogCreateAlert(wysylka)
    
    finally:
        droid.dialogShow()

        openSqLiteOut.close()
    
        if ftp is not None:
            ftp.quit()


def getPosition():

    licznik=0
    koordArr = []

    droid.startLocating(5000, 1)
    while True:
        locat = droid.readLocation()
        if 'gps' in locat.result:
            try:
                lat = str(locat.result['gps']['latitude'])
                lon = str(locat.result['gps']['longitude'])
                wysoko = str(locat.result['gps']['altitude'])

            except Exception as p:
                print ('Failure: ', p)
            else:

                licznik = licznik+1
                if licznik==4:
                    koordArr.append(lat[:11])
                    koordArr.append(lon[:11])
                    koordArr.append(wysoko[:4])
                    koordArr.append(licznik)

                    droid.stopLocating()
                    droid.dialogDismiss()

                    return koordArr

        else:
            droid.dialogCreateSpinnerProgress('Waiting for GPS signal...','Progress')
            droid.dialogShow()
        
        time.sleep(0.8)


if __name__ == "__main__":
    main()

