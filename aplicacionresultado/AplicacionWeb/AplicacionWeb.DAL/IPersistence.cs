using System.Collections.Generic;

namespace AplicacionWeb.DAL
{
    public interface IPersistence<T>
    {
        void Create(T entidad);
        void Save(T entidad);
        void Remove(int id);
        void Remove(T entidad);
        T Find(int id);
        IEnumerable<T> FindAll();
        bool IsPersistent(T entidad);
        int Count(T entidad);
    }
}
