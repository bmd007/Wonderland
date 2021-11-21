package wonderland.communication.graph.repository;

import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import org.springframework.stereotype.Repository;
import wonderland.communication.graph.domain.Person;
import wonderland.communication.graph.dto.PersonInfluenceRankDto;

import java.util.Optional;

@Repository
public interface PersonRepository extends Neo4jRepository<Person, String> {

    @Query("""
          CALL gds.pageRank.stream({
              nodeProjection: 'Person',
              relationshipProjection: 'SENT_MESSAGE_TO'
          })
          YIELD nodeId, score
          MATCH (node) WHERE id(node) = nodeId
          RETURN node.email AS email, score
          ORDER BY score DESC
          LIMIT 1""")
    PersonInfluenceRankDto getInfluenceRank();
}
