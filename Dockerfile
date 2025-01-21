# בסיס למערכת ההפעלה
FROM python:3.8

# תיקיית עבודה באפליקציה
WORKDIR /usr/src/app

# העתקת כל הקבצים
COPY . .

# התקנת ספריות Python הנדרשות
RUN pip install --no-cache-dir -r requirements.txt

# חשיפת הפורט שהאפליקציה תאזין לו
EXPOSE 5000

# הפעלת האפליקציה
CMD ["python", "./app.py"]