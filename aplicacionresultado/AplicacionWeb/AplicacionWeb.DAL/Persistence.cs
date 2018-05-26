using System.Collections.Generic;
using System.Linq;
using AplicacionWeb.Models;

namespace AplicacionWeb.DAL
{
    public class Persistence<T> : IPersistence<T> where T : Entity, new()
    {
        public void Save(T entidad)
        {
            using (var db = new ApplicationDbContext())
            {
                db.Entry(entidad).State = System.Data.Entity.EntityState.Modified;
                db.SaveChanges();
            }
        }

        public void Create(T entidad)
        {
            using (var db = new ApplicationDbContext())
            {
                db.Entry(entidad).State = System.Data.Entity.EntityState.Added;
                db.SaveChanges();
            }
         }

        public void Remove(int id)
        {
            using (var db = new ApplicationDbContext())
            {
                var entidad = new T() { Id = id };
                db.Entry(entidad).State = System.Data.Entity.EntityState.Deleted;
                db.SaveChanges();
            }
        }

        public void Remove(T entidad)
        {
            using (var db = new ApplicationDbContext())
            {
                db.Entry(entidad).State = System.Data.Entity.EntityState.Deleted;
                db.SaveChanges();
            }
        }

        public T Find(int id)
        {
            var db = new ApplicationDbContext();
            return db.Set<T>().FirstOrDefault(x => x.Id == id);
        }

        public IEnumerable<T> FindAll()
        {
            var db = new ApplicationDbContext();
            return db.Set<T>().ToList();
        }

        public bool IsPersistent(T entidad)
        {
            using (var db = new ApplicationDbContext())
            {
                bool exist = false;
                if (db.Set<T>().Where(x => x.Id.Equals(entidad.Id)).Count() > 0)
                {
                    exist = true;
                }

                return exist;
            }
        }

        public int Count(T entidad)
        {
            using (var db = new ApplicationDbContext())
            {
                return db.Set<T>().Count();
            }
        }
    }
}