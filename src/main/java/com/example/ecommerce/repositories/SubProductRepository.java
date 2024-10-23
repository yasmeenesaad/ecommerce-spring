package com.example.ecommerce.repositories;

import com.example.ecommerce.models.SubProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;


import java.util.List;
@Repository
public interface SubProductRepository extends JpaRepository<SubProduct, Integer> ,CustomSubProductRepository {
    @Query("select sub from SubProduct sub where sub.product.id=?1")
    List<SubProduct> findSubProductsByProductID(Integer productId);

    @Query("select sub from SubProduct sub where sub.product.subCategory.category.id=?1")
    List<SubProduct> findSubProductsByCategory(int categoryId) ;

    @Query("select sub from SubProduct sub where sub.product.subCategory.name=?1")
    List<SubProduct> findBySubCategoryName(String subCategoryName) ;

//    @Modifying
//    @Query(" update  from SubProduct set stock=?2 , price=?3 ,imageURL=?4 where id=?1 ")
//    void updateSubProduct(String subProductId, Integer stock, BigDecimal price, String imageUrl);
@Query("select count(c) from SubProduct c")
Long countSubProducts();

    List<SubProduct> findByIsDeletedFalse();
}